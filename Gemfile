# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Quality Control
  gem 'brakeman', '~> 4.8.2'
  gem 'rubocop', '~> 0.86.0'

  # Automating quality control
  gem 'guard', '~> 2.16' # NOTE: this is necessary in newer versions
  gem 'guard-brakeman', '~> 0.8.6'
  gem 'guard-minitest', '~> 2.4', '>= 2.4.6'
  gem 'guard-rubocop', '~> 1.3'

  # For staying ahead of gem issues
  gem 'bundler-audit', '~> 0.7.0.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  # For improved test formatting
  gem 'minitest', '~> 5.13'
  # gem 'minitest-reporters', '~> 1.4', '>= 1.4.2'
  gem 'minitest-reporters', git: 'https://github.com/garrettdimon/minitest-reporters.git', branch: 'master'
  # gem 'minitest-reporters', path: '/Users/garrettdimon/Code/minitest-reporters'

  gem 'rb-readline', '~> 0.5.5'
end
