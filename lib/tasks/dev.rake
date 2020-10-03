desc 'Wraps all things dev environment for more convenient usage'
namespace :dev do
  desc 'Wipes out and rebuilds all the things locally for a fresh start'
  task verify: %i[webpacker:check_node webpacker:check_yarn webpacker:verify_install] do
  end

  desc 'Starts all relevant processes using Overmind + the Dev Procfile'
  task start: %i[install] do
    system("overmind start -f ./Procfile.dev")
  end

  desc 'Runs all the possible steps to get the server to pick up changes'
  task reset: %i[dev:refresh] do
    system("touch tmp/restart.txt")
    system("puma-dev -stop")
    system("overmind quit")
  end

  desc 'Wipes out and rebuilds all the things locally for a fresh start'
  task refresh: %i[tmp:clear log:clear assets:clobber] do
    system("rm -rf ./node_modules")
    system("yarn install")
  end

  desc 'Installs dependencies'
  task :install do
    system("yarn install")
    system("bundle install")
  end

  desc 'Upgrades dependencies'
  task :upgrade do
    system("yarn upgrade")
    system("bundle update")
  end

  desc 'Runs migrations for dev and test'
  task :migrate do
    Rake::Task["db:migrate"].execute

    ENV['RAILS_ENV'] = 'test'
    Rake::Task["db:migrate"].execute
  end

  desc 'Reruns the latest migration for dev and test'
  task :remigrate do
    latest_migration = Dir.glob("./db/migrate/*.rb").max_by { |file| File.mtime(file) }

    unless latest_migration.nil?
      version = latest_migration.match(/.\/db\/migrate\/(\d+)_.+\.rb/)[1]
      ENV['VERSION'] = version

      Rake::Task["db:migrate:down"].execute
      Rake::Task["db:migrate"].execute

      ENV['RAILS_ENV'] = 'test'
      Rake::Task["db:migrate:down"].execute
      Rake::Task["db:migrate"].execute
    end
  end
end
