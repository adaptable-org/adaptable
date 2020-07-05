namespace :code do
  task :review do
    # Yarn Audit will always find warnings, so only raise an issue if it's moderate (4) or higher
    # See: https://classic.yarnpkg.com/en/docs/cli/audit#toc-yarn-audit
    yarn_audit_result = -> { system('yarn audit --level moderate > /dev/null'); $?.exitstatus < 4; }.call

    failures = []
    checks = {
      yarn_audit: yarn_audit_result,
      bundler_audit: 'bundle exec bundle-audit check --update --quiet',
      minitest: 'DISABLE_SPRING=1 bundle exec rails test',
      brakeman: 'bundle exec brakeman --quiet',
      rubocop: 'bundle exec rubocop --parallel --format q',
      stylelint: 'yarn stylelint . --quiet',
      eslint: 'yarn eslint . --quiet',
      prettier: 'yarn prettier --check .',
    }

    puts "\nReviewing:"
    checks.each do |check, command|
      puts "- #{check}"
      result = system("#{command} > /dev/null")
      failures << "#{check}: #{$?.exitstatus}" unless result
    end

    if failures.any?
      puts "\nFailures:"
      failures.map { |failure| puts "- #{failure}"}
    else
      puts "\nEverything checks out!"
    end

  end

  task :format do
    failures = []
    formatters = {
      rubocop: 'bundle exec rubocop --auto-correct',
      stylelint: 'yarn stylelint --fix .',
      eslint: 'yarn eslint --fix .',
      prettier: 'yarn prettier --write .',
    }

    puts "\nFormatting:"
    formatters.each do |formatter, command|
      puts "- #{formatter}"
      system("#{command} > /dev/null")
    end
  end
end
