desc 'Wraps all things code reviewing and formatting for easier and more consistent usage'
namespace :code do
  class InvalidCheck < StandardError; end
  class MissingFormatCommand < StandardError; end
  class MissingReviewCommand < StandardError; end

  # Centralize the various command-line checks to keep them consistent between dev, GitHub Actions, and Heroku Builds.
  # It also helps ensure the various flavors of the commands can be held consistent across different environments
  # without having to remember each command's options/syntax.
  #
  # Yarn Audit will always find low-level warnings, so only raise an issue if it's moderate (4) or higher.
  # max_exit_status: 3
  # See: https://classic.yarnpkg.com/en/docs/cli/audit#toc-yarn-audit
  CHECKS = {
    yarn: {
      command: 'yarn audit --level moderate',
      quiet: '',
      max_exit_status: 3,
    },
    bundler: {
      command: 'bundle exec bundle-audit check --update',
      quiet: '--quiet',
    },
    minitest: {
      command: 'COVERAGE=true DISABLE_SPRING=1 bundle exec rails test',
      quiet: '',
    },
    system_tests: {
      command: 'DISABLE_SPRING=1 bundle exec rails test:system',
      quiet: '',
    },
    brakeman: {
      command: 'bundle exec brakeman',
      quiet: '--quiet',
    },
    rubocop: {
      command: 'bundle exec rubocop --parallel',
      format: 'bundle exec rubocop --auto-correct',
      quiet: '--format q',
    },
    stylelint: {
      command: 'yarn stylelint .',
      format: 'yarn stylelint --fix .',
      quiet: '--quiet',
    },
    eslint: {
      command: 'yarn eslint .',
      format: 'yarn eslint --fix .',
      quiet: '--quiet',
    },
    prettier: {
      command: 'yarn prettier --check .',
      format: 'yarn prettier --write .',
      quiet: '',
    },
    alex: {
      command: 'yarn alex',
      quiet: '--quiet',
    },
    yardstick: {
      command: 'bundle exec rake code:review:docs',
      quiet: '',
    }
  }

  desc 'Kicks off Guard with a bundler/yarn run'
  task :watch do
    return unless Rails.env.development?

    exec 'bundle exec guard'
  end

  desc 'Shortcut for reviewing everything'
  task review: 'review:all'

  desc 'Shortcut for formatting everything'
  task format: 'format:all'

  desc 'Handles the various automated tests and static analysis tasks'
  namespace :review do

    desc 'Runs all dependency, tests, security, and syntax checks in order of risk/importance'
    task all: %w[dependencies tests security syntax language documentation coverage]

    desc 'Audits Bundler and Yarn dependencies'
    task :dependencies do
      review_group(:dependency, %i[yarn bundler])
    end

    desc 'Runs minitest and system tests'
    task :tests do
      review_group(:testing, %i[minitest system_tests])
    end

    desc 'Runs static analysis security checks'
    task :security do
      review_group(:security, %i[brakeman])
    end

    desc 'Runs syntax checks'
    task :syntax do
      review_group(:syntax, %i[rubocop stylelint eslint prettier])
    end

    desc 'Runs language checks'
    task :language do
      review_group(:language, %i[alex])
    end

    desc 'Runs language checks'
    task :documentation do
      review_group(:documentation, %i[yardstick])
    end

    desc 'Runs minitest and opens the coverage report'
    task coverage: %i[tests] do
      system 'open coverage/index.html'
    end

    desc 'Runs yardstick checks'
    task :docs do
      require 'yardstick/rake/measurement'
      require 'yardstick/rake/verify'

      options = YAML.load_file('./.yardstick.yml')

      task = Yardstick::Rake::Measurement.new(:yardstick_measure, options)
      task.yardstick_measure

      task = Yardstick::Rake::Verify.new(:verify_measurements, options)
      task.verify_measurements
    rescue
      # Output the failures
      system('cat ./measurements/report.txt')
      raise
    end

    private

      def review_group(group_name, group_checks)
        failures = []
        group_name = group_name.capitalize

        puts "#{group_name}:"
        group_checks.map { |check| failures << review_one(check) }
        puts "\n"

        failures.compact!

        failures.map { |command| system(command) }

        exit failures.size if failures.any?
      end

      def review_one(check_symbol)
        # Must have a relevant review command to run
        raise InvalidCheck, "':#{check_symbol}' - #{CHECKS.keys}" unless CHECKS.dig(check_symbol)
        raise MissingReviewCommand, "No review command for #{check_symbol}" unless CHECKS.dig(check_symbol, :command)

        check = CHECKS.dig(check_symbol)
        command = CHECKS.dig(check_symbol, :command)

        if Rails.env.development?
          # Note which check is running...
          print "➤ #{check_symbol}"
          # But run it quietly...
          system("#{command} #{check[:quiet]} > /dev/null")
        else
          # Run it with all of its glorious output
          system(command)
        end

        safe_exit_status = $?.exitstatus <= check.fetch(:max_exit_status, 0)

        if safe_exit_status
          puts " ✔"
          nil
        else
          puts " ✘ (`#{command}` exited with #{$?.exitstatus} )"
          command
        end
      end
  end

  desc 'Simplifies automated formatting of syntax issues'
  namespace :format do

    desc 'Runs all syntax formatters'
    task all: %w[backend frontend]

    desc 'Runs formatters for back-end code'
    task :backend do
      format_group(:backend, %i[rubocop])
    end

    desc 'Runs formatters for front-end code'
    task :frontend do
      format_group(:frontend, %i[stylelint eslint prettier])
    end

    private

      def format_group(group_name, group_checks)
        puts "\n#{group_name.capitalize} Formatting:"
        group_checks.each { |check| format_one(check) }
      end

      def format_one(check_symbol)
        # Don't accidentally update any code outside of dev
        return unless Rails.env.development?

        # If the check doesn't have a key for formatting, it can't be run
        raise InvalidCheck, "':#{check_symbol}' - #{CHECKS.keys}" unless CHECKS.dig(check_symbol)
        raise MissingFormatCommand, "No format command for #{check_symbol}" unless CHECKS.dig(check_symbol, :format)

        check = CHECKS.fetch(check_symbol)
        command = CHECKS.dig(check_symbol, :format)

        puts "- #{check_symbol}"
        system("#{command} > /dev/null")
      end
  end
end
