# Seeding for Adaptable is designed to be Idempotent so that it can safely be re-run to add new activities,
# disabilities, organizations, offerings, etc. or tweak data about them as they change. Near-term, this
# saves us from having to build a UI for managing the core data.

module Seeds
  class << self
    def load_all
      Activities.new.load!
      Disabilities.new.load!
      Organizations.new.load!
      Grants.new.load!
    end
  end

  # Base class for seeding required data for any environment.
  # - Loads the seed data, but ensures existing data is never duplicated.
  # - Updates or fills in new attributes.
  # - Facilitates safely updating activity/disability tags for a given model.
  class Loader
    def object_class
      self.class.name.to_s.demodulize.singularize.constantize
    end

    def records_type
      self.class.name.to_s.demodulize.downcase
    end

    def seeds_path
      Rails.root.join('db', 'seeds', "#{records_type}.yml")
    end

    def records
      @records ||= YAML.load_file(seeds_path)
    end

    def load!
      puts
      puts "Loading #{records_type}"
      records.each { |record| create_or_update!(record) }
      puts
    end

    def key_for(record)
      record['key'] || record['name'].parameterize
    end

    def find_or_initialize(record, polymorphic_class = nil)
      key = key_for(record)
      class_name = polymorphic_class || object_class
      class_name.find_or_initialize_by(key: key)
    end

    def save_and_show_result(record)
      if record.save
        print '.'
      else
        puts
        puts "#{record.name} had errors: #{record.errors.full_messages}"
      end
    end

    def create_or_update!(record)
      raise NotImplementedError.new("`create_or_update!`")
    end

    def set_disabilities(record, values)
      values['disabilities'].each do |disability|
        disability_tag = Disability.find_by(key: disability)

        next if record.disabilities.include?(disability_tag)

        record.disabilities << disability_tag
      rescue => e
        puts "Failed to add `#{disability.name}` to `#{record.name}`"
        puts e.inspect
      end

      return record
    end

    def set_activities(record, values)
      values['activities'].each do |activity|
        activity_tag = Activity.find_by(key: activity)

        next if record.activities.include?(activity_tag)

        record.activities << activity_tag
      rescue => e
        puts "Failed to add `#{activity.name}` to `#{record.name}`"
        puts e.inspect
      end

      return record
    end

    def set_links(record, values)
      values['links'].each do |link|
        link_instance = record.links.find_or_initialize_by(url: link['url'])

        if link_instance.present?
          link_instance.update(
            text: link['text'],
            kind: link['kind']
          )
        else
          record.links << Link.new(
            text: link['text'],
            url: link['url'],
            kind: link['kind'],
          )
        end
      end

      return record
    end
  end

  class Activities < Loader
    def create_or_update!(activity)
      record = find_or_initialize(activity)

      record.name = activity['name']
      record.key = activity['key']
      record.wikipedia_key = activity['wikipedia_key']
      record.also_known_as = activity['also_known_as']
      record.mechanics = activity['mechanics']
      record.parent_id = Activity.find_by(key: activity['parent'])&.id

      save_and_show_result(record)
    end
  end

  class Disabilities < Loader
    def create_or_update!(disability)
      record = find_or_initialize(disability)

      record.name = disability['name']
      record.key = disability['key']
      record.description = disability['description']
      record.parent_id = Disability.find_by(key: disability['parent'])&.id

      save_and_show_result(record)
    end
  end

  class Organizations < Loader
    def create_or_update!(organization)
      record = find_or_initialize(organization)

      record.name = organization['name']
      record.key = organization['key']
      record = set_disabilities(record, organization)
      record = set_activities(record, organization)
      record = set_links(record, organization)

      save_and_show_result(record)
    end
  end

  class Grants < Loader
    def create_or_update!(grant)
      offering = find_or_initialize(grant, Offering)

      # Offering Data
      offering.key = grant['key']
      offering.name = grant['name']
      offering.summary = grant['summary']
      offering.organization = Organization.find_by(key: grant['organization'])
      offering = set_disabilities(offering, grant)
      offering = set_activities(offering, grant)

      offerable_attributes = {
        eligibility_notes: grant['eligibility_notes'],
        application_notes: grant['application_notes']
      }

      # Grant-specific data
      if offering.offerable&.persisted?
        offering.offerable.update(offerable_attributes)
      else
        offering.offerable = Grant.new(offerable_attributes)
      end

      save_and_show_result(offering)

      offering.reload
      offering = set_links(offering, grant)
      save_and_show_result(offering)
    rescue => exception
      puts
      puts exception.message
      pp exception.backtrace.to_a.select { |line| line =~ /adaptable/ }
      puts
      pp offering.key
      puts
    end
  end
end

Seeds.load_all
