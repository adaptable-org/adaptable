# frozen_string_literal: true

# Provides a consistent and predictable interface for retrieving configuration values without requiring knowledge of
# where or how the values are stored. Methods for specifically looking in settings, credentials, or ENV provide a
# consistent interface regardless of how the values use hash storage.
#
# So instead of remembering varying combinations of the following...
#
#   Rails.application.credentials.secret_key_base
#   Rails.application.credentials.aws[:secret_key]
#   Rails.configuration.settings[:public_key]
#   Rails.configuration.settings[:domain][:name]
#   ENV['ENV_VAR']
#   ENV.fetch('ENV_VAR', 'Default')
#   ENV.fetch('ENV_VAR') { 'Default' }
#
# Values can be accessed like...
#
#   Settings.secret(:secret_key_base)
#   Settings.secret(:aws, :secret_key)
#   Settings.config(:public_key)
#   Settings.config(:domain, :name)
#   Settings.env(:env_var)
#
# Or, a source-indifferent lookup could be used so that it responds differently when a match isn't found.
# With all source-indifferent lookups, if multiple matches are found, they will raise an exception to prevent
# accidentally using the wrong value from settings.yml when you wanted the value from production.yml.enc.
#
#   Settings.optional(:key)               # Returns the value
#   Settings.optional(:key_one, :key_two) # Returns the value of the nested keys
#   Settings.optional(:missing)           # Returns nil
#   Settings.critical(:key)               # Returns the value
#   Settings.critical(:key_one, :key_two) # Returns the value of the nested keys
#   Settings.critical(:missing)           # Raises exception when a critical value is missing
#   Settings.default(:key) { 'Default' }  # Provides a predictable interface for providing defaults inline.

class Settings
  class ConflictError < ::StandardError; end
  class MissingError < ::StandardError; end
end

class << Settings
  # Looks only for secrets matching the symbols.
  #
  #   Settings.secret(:key_one) # => value for :key_one
  #   Settings.secret(:key_one, :key_two) # => value for :key_two nested under :key_one
  def secret(key, *nested_keys)
    dig(key, *nested_keys) { Rails.application.credentials.__send__(key) }
  end

  # Looks only for config settings matching the symbols.
  #
  #   Settings.config(:key_one) # => value for :key_one
  #   Settings.config(:key_one, :key_two) # => value for :key_two nested under :key_one
  def config(key, *nested_keys)
    dig(key, *nested_keys) { Rails.configuration.settings[key] }
  end

  # Looks only for environment variables matching the symbol.
  #
  #   Settings.env(:key) # => value for :key
  def env(key)
    dig(key) { ENV[key.upcase.to_s] }
  end

  # Performs a lookup where returning nil is acceptable if a match is not found
  # Essentially an alias of `lookup` but with a more intention-revealing name
  #
  #   Settings.optional(:key) # => value for :key
  #   Settings.optional(:missing_key) # => nil
  def optional(key, *nested_keys)
    lookup(key, *nested_keys)
  end

  # Raises an exception if all potential sources are nil
  #
  #   Settings.critical(:key) # => value for :key
  #   Settings.critical(:missing_key) # => Raises Settings::MissingError
  def critical(key, *nested_keys)
    value = lookup(key, *nested_keys)

    # Critical settings must be present. Best to fail now.
    raise Settings::MissingError, "no value found for keys: #{[key, *nested_keys].inspect}" if value.nil?

    value
  end

  # Returns the provided default if no match is found
  #
  #   Settings.default(:key) { 'Default' } # => value for :key
  #   Settings.default(:missing_key) { 'Default' } # => Returns 'Default'
  def default(key, *nested_keys, &default)
    raise ArgumentError, 'block required for default return value' unless block_given?

    value = lookup(key, *nested_keys)

    value.nil? ? default.call : value
  end

  protected

    def lookup(key, *nested_keys)
      values = possible_values(key, *nested_keys).compact

      # Multiple matches were found, and conflicts would introduce potential for errors. Best to fail now.
      if values.size > 1
        exception_messsage = "multiple values for keys: #{[key, *nested_keys].inspect} > #{values.inspect}"
        raise Settings::ConflictError, exception_messsage
      end

      values.first
    end

    def possible_values(key, *nested_keys)
      [
        secret(key, *nested_keys),
        config(key, *nested_keys),
        env(key)
      ]
    end

    def dig(key, *nested_keys)
      raise ArgumentError, 'all arguments must be symbols' unless symbols_only?(key, *nested_keys)

      secret = yield

      nested_keys.any? ? secret&.dig(*nested_keys) : secret
    end

    def symbols_only?(*keys)
      keys.all? { |key| key.is_a? Symbol }
    end
end
