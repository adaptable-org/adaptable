desc 'Wraps all things deploy for safter, easier, and more consistent usage'
namespace :ops do
  task :disable do
    heroku 'maintenance:on'
  end

  task :enable do
    heroku 'maintenance:off'
  end

  task :migrate do
    heroku 'run rake db:migrate'
  end

  task :tail do
    heroku 'logs --tail'
  end

  task :console do
    heroku 'run rails console'
  end

  task :releases do
    heroku 'releases'
  end

  task :dashboard do
    sh "open 'https://dashboard.heroku.com/apps/adaptable-#{env(ARGV)}'"
  end  

  task :deploy do
    environment = env(ARGV)
    current_branch = `git rev-parse --abbrev-ref HEAD`.strip

    sh 'git checkout main' unless current_branch == 'main'
    sh 'git pull'
    sh "git push origin main:#{environment}"
  end

  private

    def heroku(command)
      environment = env(ARGV)
      sh "bundle exec heroku #{command} --app adaptable-#{environment}"
    end

    def env(args)
      target_environment = args.last

      # These commands should only work for staging/production
      valid_targets = %w[staging production]
      unless valid_targets.include?(target_environment)
        puts "'#{target_environment}' is not a valid environment. Must be either #{valid_targets.map{ |value| "'#{value}'"}.join(' or ')}"
        exit 1
      end

      # This dynamically creates a task representing the environment argument so rake doesn't ry to run it as a task
      task target_environment do ; end

      target_environment
    end
end
