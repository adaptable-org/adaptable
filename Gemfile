# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
# gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.8', require: false

# Exception handling
gem "honeybadger", "~> 4.7.2"

# For Markdown Processing/Rendering
gem 'redcarpet', '~> 3.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 4.0.4'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Documenation
  gem 'annotate', '~> 3.1', '>= 3.1.1'
  gem 'yard', '~> 0.9.25'
  gem 'yardstick', '~> 0.9.9'

  # Quality Control
  gem 'brakeman', '~> 4.9.0'
  gem 'bundler-audit', '~> 0.7.0.1'
  gem 'rubocop', '~> 0.89.1'

  # Automating quality control
  gem 'guard', '~> 2.16.2' # NOTE: Needs to be explicitly referenced vs. letting the others pull it in as a dependency
  gem 'guard-brakeman', '~> 0.8.6'
  gem 'guard-bundler', '~> 3.0.0'
  gem 'guard-bundler-audit', '~> 0.1.4'
  gem 'guard-minitest', '~> 2.4', '>= 2.4.6'
  gem 'guard-rubocop', '~> 1.3'
  gem 'guard-shell', '~> 0.7.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  # Minitest & Reporting
  gem 'minitest', '~> 5.13'
  gem 'simplecov', '~> 0.19.0', require: false

  # For improved test formatting. Your choice.
  gem 'minitest-reporters', git: 'https://github.com/garrettdimon/minitest-reporters.git', branch: 'master'
  # gem 'minitest-reporters', '~> 1.4', '>= 1.4.2'

  gem 'rb-readline', '~> 0.5.5'
end
