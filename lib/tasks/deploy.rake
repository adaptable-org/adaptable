desc 'Wraps all things deploy for safter, easier, and more consistent usage'
namespace :ops do

  task :dashboard do
    dashboard env(ARGV)
  end

  task :disable do
    disable env(ARGV)
  end

  task :enable do
    enable env(ARGV)
  end

  task :deploy do
    deploy env(ARGV)
  end

  task :migrate do
    migrate env(ARGV)
  end

  task :tail do
    tail env(ARGV)
  end

  task :console do
    console env(ARGV)
  end

  task :releases do
    releases env(ARGV)
  end

  private

    def dashboard(environment)
      sh 'open "https://dashboard.heroku.com/apps/adaptable-#{environment}"'
    end

    def disable(environment)
      heroku('maintenance:on', environment)
    end

    def enable(environment)
      heroku('maintenance:off', environment)
    end

    def deploy(environment)
      target_environment = environment
      current_branch = `git rev-parse --abbrev-ref HEAD`.strip

      sh 'git checkout main' unless current_branch == 'main'
      sh 'git pull'

      sh "git push origin main:#{target_environment}"
    end

    def migrate(environment)
      heroku('run rake db:migrate', environment)
    end

    def tail(environment)
      heroku('logs --tail', environment)
    end

    def console(environment)
      heroku('run rails console', environment)
    end

    def releases(environment)
      heroku('releases', environment)
    end

    def heroku(command, environment)
      sh "bundle exec heroku #{command} --app adaptable-#{environment}"
    end

    def env(args)
      target_environment = args.last.to_sym

      # This dynamically creates a task representing the environment argument so rake doesn't ry to run it
      task target_environment do ; end

      target_environment
    end
end
