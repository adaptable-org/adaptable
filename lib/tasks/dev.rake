desc 'Wraps all things dev environment for more convenient usage'
namespace :dev do
  desc 'Wipes out and rebuilds all the things locally for a fresh start'
  task verify: %i[webpacker:check_node webpacker:check_yarn webpacker:verify_install] do
  end

  desc 'Starts all relevant processes using Overmind + the Dev Procfile'
  task :start do
    system("overmind start -f ./Procfile.dev")
  end

  desc 'Runs all the possible steps to get the server to pick up changes'
  task restart: %i[dev:refresh] do
    system("touch tmp/restart.txt")
    system("puma-dev -stop")
  end

  desc 'Wipes out and rebuilds all the things locally for a fresh start'
  task refresh: %i[tmp:clear log:clear assets:clobber] do
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
end
