desc 'Wraps all things deploy for safter, easier, and more consistent usage'
namespace :ops do
  desc 'Open Adaptable Pipeline on Heroku'
  task :pipeline do
    open 'https://dashboard.heroku.com/pipelines/09559d77-2bcd-43b4-bc05-5cb152cdaad7'
  end

  namespace :staging do |staging|
    task :dashboard do
      dashboard(staging)
    end

    task :disable do
      disable(staging)
    end

    task :enable do
      enable(staging)
    end

    task :deploy do
      deploy(staging)
    end

    task :migrate do
      migrate(staging)
    end

    task :tail do
      tail(staging)
    end

    task :console do
      console(staging)
    end

    task :releases do
      releases(staging)
    end
  end

  namespace :production do |production|
    task :dashboard do
      dashboard(production)
    end

    task :disable do
      disable(production)
    end

    task :enable do
      enable(production)
    end

    task :deploy do
      deploy(production)
    end

    task :migrate do
      migrate(production)
    end

    task :tail do
      tail(production)
    end

    task :console do
      console(production)
    end

    task :releases do
      releases(production)
    end
  end

  private

    def dashboard(namespace)
      exec 'open "https://dashboard.heroku.com/apps/adaptable-#{env(namespace)}"'
    end

    def disable(namespace)
      heroku('maintenance:on', namespace)
    end

    def enable(namespace)
      heroku('maintenance:off', namespace)
    end

    def deploy(namespace)
      target_environment = env(namespace)
      current_branch = `git rev-parse --abbrev-ref HEAD`.strip

      exec 'git stash'
      exec 'git checkout main' unless current_branch == 'main'
      exec 'git pull'

      exec "git push origin main:#{target_environment}"
    end

    def migrate(namespace)
      heroku('run rake db:migrate', namespace)
    end

    def tail(namespace)
      heroku('logs --tail', namespace)
    end

    def console(namespace)
      heroku('run rails console', namespace)
    end

    def releases(namespace)
      heroku('releases', namespace)
    end

    def heroku(command, namespace)
      exec "bundle exec heroku #{command} --app adaptable-#{env(namespace)}"
    end

    def env(namespace)
      namespace.scope.path.split(':').last
    end
end
