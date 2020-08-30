# frozen_string_literal: true

Rails.application.configure do
  # Load config/settings.yml -> Rails.configuration.settings
  config.settings = config_for(:settings)

  # Get config/env.yml values
  environment_variables = config_for(:env)

  # Tranlate YAML symbolized keys to environment variable keys. i.e. :key -> 'KEY'
  environment_variables.transform_keys! { |key| key.to_s.upcase }

  # Discard any values for which an environment variable has already been set
  environment_variables.reject! { |key| ENV.key?(key) }

  # Load the remaining values into ENV if an equivalen tkey doesn't already exist
  environment_variables.each { |key, value| ENV.store(key, value) }
end
