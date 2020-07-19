desc 'Wraps all things deploy for safter, easier, and more consistent usage'
namespace :ops do
  desc 'Puts up the maintenance page via Heroku'
  task :disable do
    heroku 'maintenance:on'
  end

  desc 'Takes down the maintenance page via Heroku'
  task :enable do
    heroku 'maintenance:off'
  end

  desc 'Runs migrations on server via Heroku'
  task :migrate do
    heroku 'run rake db:migrate'
  end

  desc 'Tails server logs via Heroku'
  task :tail do
    heroku 'logs --tail'
  end

  desc 'Opens console on server via Heroku'
  task :console do
    heroku 'run rails console'
  end

  desc 'Lists recent releases via Heroku'
  task :releases do
    heroku 'releases'
  end

  desc 'Runs a code review, and, if it passes, pushes to the relevant branch to trigger a deploy'
  task deploy: %i[code:review] do
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
        valid_targets_string = valid_targets.map{ |value| "'#{value}'"}.join(' or ')
        puts "'#{target_environment}' is not a valid environment. Must be either #{valid_targets_string}"
        exit 1
      end

      # This dynamically creates a task representing the environment argument so rake doesn't ry to run it as a task
      task target_environment do ; end

      target_environment
    end
end
