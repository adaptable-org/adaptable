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
# Settings provides a set of source-indifferent lookup options that respond differently when a match isn't found.
# With all source-indifferent lookups, if multiple matches are found, they will raise an exception to prevent
# accidentally using the wrong value from settings.yml when you wanted the value from production.yml.enc.
#
#   Settings.optional(:key)                   # => Returns the value
#   Settings.optional(:key_one, :key_two)     # => Returns the value of the nested keys
#   Settings.optional(:missing)               # => Returns nil
#   Settings.required(:key)                   # => Returns the value
#   Settings.required(:key_one, :key_two)     # => Returns the value of the nested keys
#   Settings.required(:missing)               # => Raises exception when a critical value is missing
#   Settings.default(:key) { 'Default' }      # => Returns the value and ignores the default.
#   Settings.default(:missing) { 'Default' }  # => Returns 'Default'
#
# For convenience and syntactic sugar, optional and default lookups can use the key names directly.
# This will not work as a substitute for required lookups.
#
#   Settings.key                              # => Same as Settings.optional(:key)
#   Settings.key_one(:key_two)                # => Same as Settings.optional(:key_one, :key_two)
#   Settings.key { 'Default' }                # => Same as Settings.default(:key) { 'Default' }
#   Settings.key_one(:key_two) { 'Default' }  # => Same as Settings.default(:key_one, :key_two) { 'Default' }
#
# Values can also be accessed by their expected source location as well. If there's a case where there are source
# conflicts with multiple sources, those can be avoided by specifying the source like so:
#
#   Settings.secret(:secret_key_base)
#   Settings.secret(:aws, :secret_key)
#   Settings.config(:public_key)
#   Settings.config(:domain, :name)
#   Settings.env(:env_var)
#
# One final caveat. As one might expect, there is a performance difference between accessing values directly using the
# existing built-in Rails approaches, but for the majority of use cases where these values would be accessed, the
# difference should be marginal.
class Settings
  class ConflictError < ::StandardError; end
  class MissingError < ::StandardError; end

  class << self
    # Looks only for secrets matching the symbols
    #
    # @example
    #   Settings.secret(:key_one) # => value for :key_one
    #   Settings.secret(:key_one, :key_two) # => value for :key_two nested under :key_one
    #
    # @param key [Symbol] first-level key to desired settings value
    # @param nested_keys [*Symbol] additional keys for nested settings values
    #
    # @return [String, Boolean, Integer] the value of the setting
    #
    # @raise [Settings::MissingError] if an exact match is not found in the credentials
    def secret(key, *nested_keys)
      dig(key, *nested_keys) { Rails.application.credentials.__send__(key) }
    end

    # Looks only for config settings matching the symbols
    #
    # @example
    #   Settings.config(:key_one) # => value for :key_one
    #   Settings.config(:key_one, :key_two) # => value for :key_two nested under :key_one
    #
    # @param key [Symbol] first-level key to desired settings value
    # @param nested_keys [*Symbol] additional keys for nested settings values
    #
    # @return [String, Boolean, Integer] the value of the setting
    #
    # @raise [Settings::MissingError] if an exact match is not found in the configuration settings
    def config(key, *nested_keys)
      dig(key, *nested_keys) { Rails.configuration.settings[key] }
    end

    # Looks only for environment variables matching the symbol
    #
    # @example
    #   Settings.env(:key) # => value for :key
    #
    # @param key [Symbol] first-level key to desired settings value
    # @param nested_keys [*Symbol] additional keys for nested settings values
    #
    # @return [String, Boolean, Integer] the value of the setting
    #
    # @raise [Settings::MissingError] if an exact match is not found in the ENV values
    def env(key)
      dig(key) { ENV[key.upcase.to_s] }
    end

    # Performs a lookup where returning nil is acceptable if a match is not found
    #
    # @note Essentially an alias of `lookup` but with a more intention-revealing name
    #
    # @example
    #   Settings.optional(:key) # => value for :key
    #   Settings.optional(:missing_key) # => nil
    #
    # @param key [Symbol] first-level key to desired settings value
    # @param nested_keys [*Symbol] additional keys for nested settings values
    #
    # @return [String, Boolean, Integer, nil] the value of the setting
    #
    # @raise [Settings::ConflictError] if a set of keys finds values in more than one location
    def optional(key, *nested_keys)
      lookup(key, *nested_keys)
    end

    # Lookup that raises an exception if all potential sources are nil
    #
    # @note Essentially an alias of `lookup` but with a more intention-revealing name
    #
    # @example
    #   Settings.required(:key) # => value for :key
    #   Settings.required(:missing_key) # => Raises Settings::MissingError
    #
    # @param key [Symbol] first-level key to desired settings value
    # @param nested_keys [*Symbol] additional keys for nested settings values
    #
    # @return [String, Boolean, Integer] the value of the setting
    #
    # @raise [Settings::ConflictError] if a set of keys finds values in more than one location
    # @raise [Settings::MissingError] if an exact match is not found
    def required(key, *nested_keys)
      value = lookup(key, *nested_keys)

      # Critical settings must be present. Best to fail now.
      raise Settings::MissingError, "no value found for keys: #{[key, *nested_keys].inspect}" if value.nil?

      value
    end

    # Returns the provided default if no match is found
    #
    # @example
    #   Settings.default(:key) { 'Default' } # => value for :key
    #   Settings.default(:missing_key) { 'Default' } # => Returns 'Default'
    #
    # @param key [Symbol] first-level key to desired settings value
    # @param nested_keys [*Symbol] additional keys for nested settings values
    # @param default [Block] a block to evaluate to derive the default if no match is found
    #
    # @return [String, Boolean, Integer] the value of the setting
    #
    # @raise [ArgumentError] if a block is not provided
    # @raise [Settings::ConflictError] if a set of keys finds values in more than one location
    def default(key, *nested_keys, &default)
      raise ArgumentError, 'block required for default return value' unless block_given?

      value = lookup(key, *nested_keys)

      value.nil? ? default.call : value
    end

    # Syntactic sugar to expose lookups as attributes rather than hash keys
    #
    # @example
    #   Settings.key                              # => Same as Settings.optional(:key)
    #   Settings.key_one(:key_two)                # => Same as Settings.optional(:key_one, :key_two)
    #   Settings.key { 'Default' }                # => Same as Settings.default(:key) { 'Default' }
    #   Settings.key_one(:key_two) { 'Default' }  # => Same as Settings.default(:key_one, :key_two) { 'Default' }
    #
    # @return [String, Boolean, Integer] the value of the setting
    def method_missing(key, *nested_keys, &default)
      value = lookup(key, *nested_keys)

      value = default.call if value.nil? && block_given?

      value.nil? ? super : value
    end

    # rubocop:disable Style/OptionalBooleanParameter
    # Overriding respond_to_missing? and can't change the inherited interface

    # Ensures class is respond_to? friendly when using method_missing
    #
    # @api private
    def respond_to_missing?(key, include_private = false)
      [secret(key), config(key), env(key)].any? || super
    end
    # rubocop:enable Style/OptionalBooleanParameter

    private

      # A standardized way for performing lookups across all possible sources
      #
      # @api private
      #
      # @param key [Symbol] first-level key to desired settings value
      # @param nested_keys [*Symbol] additional keys for nested settings values
      #
      # @return [String, Boolean, Integer] the value of the setting
      #
      # @raise [Settings::ConflictError] if a set of keys finds values in more than one location
      def lookup(key, *nested_keys)
        values = possible_values(key, *nested_keys).compact

        # Multiple matches were found, and conflicts would introduce potential for errors. Best to fail now.
        if values.size > 1
          exception_messsage = "multiple values for keys: #{[key, *nested_keys].inspect} > #{values.inspect}"
          raise Settings::ConflictError, exception_messsage
        end

        values.first
      end

      # Builds an array of possible results from the various lookups
      #
      # @api private
      #
      # @param key [Symbol] first-level key to desired settings value
      # @param nested_keys [*Symbol] additional keys for nested settings values
      #
      # @return [Array<String, Boolean, Integer>] the arroy values for which a match was found
      def possible_values(key, *nested_keys)
        [
          secret(key, *nested_keys),
          config(key, *nested_keys),
          env(key)
        ]
      end

      # A slightly customized version of dig for retrieving settings
      #
      # @api private
      #
      # @example
      #  dig(key, *nested_keys) { Rails.application.credentials.__send__(key) }
      #  dig(key, *nested_keys) { Rails.configuration.settings[key] }
      #  dig(key) { ENV[key.upcase.to_s] }
      #
      # @param key [Symbol] first-level key to desired settings value
      # @param nested_keys [*Symbol] additional keys for nested settings values
      # @yield [Value] for providing and handling default vaues for various settings locations
      #
      # @return [Boolean] true if all keys are symbols, false otherwise
      def dig(key, *nested_keys)
        raise ArgumentError, 'all arguments must be symbols' unless symbols_only?(key, *nested_keys)

        secret = yield

        nested_keys.any? ? secret&.dig(*nested_keys) : secret
      end

      # Detects whether all parameters are keys
      #
      # @api private
      #
      # @param keys [*Symbol] additional keys for nested settings values
      #
      # @return [Boolean] true if all keys are symbols, false otherwise
      def symbols_only?(*keys)
        keys.all? { |key| key.is_a? Symbol }
      end
  end
end
