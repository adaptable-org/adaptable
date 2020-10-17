desc 'Wraps all things dev environment for more convenient usage'
namespace :dev do
  desc 'Ensures foundational thing are in place'
  task verify: %i[webpacker:check_node webpacker:check_yarn webpacker:verify_install] do
  end

  desc 'Starts all relevant processes using Overmind + the Dev Procfile'
  task start: %i[install] do
    system("overmind start -f ./Procfile.dev")
  end

  desc 'Runs all the possible steps to get the server to pick up changes'
  task reset: %i[tmp:clear log:clear assets:clobber] do
    system("rm -rf ./node_modules")
    system("touch tmp/restart.txt")
    system("puma-dev -stop")
    system("overmind quit")
    system("yarn install")
  end

  desc 'Builds and opens documentation'
  task :doc do
    system("be yard doc")
    system("open doc/_index.html")
  end

  desc 'rbenv convenience for available Ruby versions'
  task :rubies do
    # Make sure we have the latest full list.
    system("brew upgrade rbenv ruby-build")
    # Show all available core ruby versions
    system("rbenv install --list-all | grep --color '^[2-3]\.[0-9]\.[0-9]-*.*$'")
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
