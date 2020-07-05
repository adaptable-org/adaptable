# frozen_string_literal: true

require 'simplecov' # See `/.simplecov` for configuration

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # For SimpleCov and Spring - https://github.com/colszowka/simplecov#want-to-use-spring-with-simplecov
  Rails.application.eager_load!

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
