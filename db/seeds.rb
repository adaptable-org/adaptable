# Disabilities
disabilities_path = Rails.root.join('db', 'seeds', 'disabilities.yml')
disabilities = YAML.load_file(disabilities_path)

before = Disability.count
puts "#{before} disabilities before seeding."
disabilities.each do |disability|
  # Find the existing record...
  record = Disability.find_by(name: disability['name'])
  # ...or start a new one.
  record ||= Disability.new

  record.name ||= disability['name']
  record.key = disability['key']
  record.description = disability['description']
  record.parent_id = Disability.find_by(key: disability['parent'])&.id
  record.save
end
after = Disability.count
puts "#{after} disabilities after seeding."



# Organizations
organizations_path = Rails.root.join('db', 'seeds', 'organizations.yml')
organizations = YAML.load_file(organizations_path)

before = Organization.count
puts "#{before} organizations before seeding."
organizations.each do |org|
  # Find the existing record...
  record = Organization.find_by(name: org['name'])
  # ...or start a new one.
  record ||= Organization.new

  record.name ||= org['name']
  record.key = org['key']
  record.url = org['url']
  org['disabilities'].each do |disability|
    disability_tag = Disability.find_by(key: disability)

    next if record.disabilities.include?(disability_tag)

    record.disabilities << Disability.find_by(key: disability)
  end
  record.save
end
after = Organization.count
puts "#{after} organizations after seeding."
