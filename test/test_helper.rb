# frozen_string_literal: true

require 'simplecov' # See `/.simplecov` for configuration

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'minitest/reporters'

class ActiveSupport::TestCase
  # Let's use the custom "Focus" minitest reporters...
  # Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
  Minitest::Reporters.use! Minitest::Reporters::FocusReporter.new

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
