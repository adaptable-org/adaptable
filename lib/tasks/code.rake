namespace :code do
  def checks
    # Yarn Audit will always find low-level warnings, so only raise an issue if it's moderate (4) or higher
    # See: https://classic.yarnpkg.com/en/docs/cli/audit#toc-yarn-audit
    {
      yarn: {
        review: 'yarn audit --level moderate',
        quiet: '',
        max_exit_status: 3,
      },
      bundler: {
        review: 'bundle exec bundle-audit check --update',
        quiet: '--quiet',
        max_exit_status: 0,
      },
      minitest: {
        review: 'COVERAGE=true DISABLE_SPRING=1 bundle exec rails test',
        quiet: '',
        max_exit_status: 0,
      },
      brakeman: {
        review: 'bundle exec brakeman',
        quiet: '--quiet',
        max_exit_status: 0,
      },
      rubocop: {
        review: 'bundle exec rubocop --parallel',
        format: 'bundle exec rubocop --auto-correct',
        quiet: '--format q',
        max_exit_status: 0,
      },
      stylelint: {
        review: 'yarn stylelint .',
        format: 'yarn stylelint --fix .',
        quiet: '--quiet',
        max_exit_status: 0,
      },
      eslint: {
        review: 'yarn eslint .',
        format: 'yarn eslint --fix .',
        quiet: '--quiet',
        max_exit_status: 0,
      },
      prettier: {
        review: 'yarn prettier --check .',
        format: 'yarn prettier --write .',
        quiet: '',
        max_exit_status: 0,
      },
    }
  end

  def review(check_symbol)
    return unless checks.key?(check_symbol)

    check = checks[check_symbol]

    command = check[:review]
    quiet = check[:quiet]
    max_exit_status = check[:max_exit_status]

    puts "- #{check_symbol}"
    system("#{command} #{quiet} > /dev/null")
    result = $?.exitstatus <= max_exit_status

    if result
      nil
    else
      "#{check_symbol}:#{$?.exitstatus}\n  #{command}"
    end
  end

  task :review do
    failures = []

    puts "\nReviewing:"
    checks.keys.each do |check|
      failures << review(check)
    end

    failures.compact!

    if failures.any?
      puts "\nFailures:"
      failures.map { |failure| puts "- #{failure}"}
    else
      puts "\nEverything checks out!"
    end
  end

  task :format do
    failures = []

    puts "\nFormatting:"
    checks.each do |check, options|
      next unless options.key?(:format)

      puts "- #{check}"
      system("#{options[:format]} > /dev/null")
    end

    puts "\nGo look at the updated code!"
  end
end
