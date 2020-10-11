# frozen_string_literal: true

# Wrapper for abstracting exception reporting. Prevents exception handling from being tightly coupled to a single vendor
# and provides some convenience methods for common exception-handling practices.
class Surprise
  class << self
    # Reports an exception to Honeybadger
    #
    # @example
    #  begin
    #    raise StandardError
    #  rescue StandardError => exception
    #    Surprise.record(exception, tags: 'critical')
    #  end
    #
    # @api public
    #
    # @param [Exception, Hash, Object] exception_or_opts An Exception object,
    #   or a Hash of options which is used to build the notice. All other types
    #   of objects will be converted to a String and used as the :error_message.
    # @param [Hash] opts The options Hash when the first argument is an Exception.
    #
    # @option opts [String]    :error_message The error message.
    # @option opts [String]    :error_class ('Notice') The class name of the error.
    # @option opts [Array]     :backtrace The backtrace of the error (optional).
    # @option opts [String]    :fingerprint The grouping fingerprint of the exception (optional).
    # @option opts [Boolean]   :force (false) Always report the exception when true, even when ignored (optional).
    # @option opts [Boolean]   :sync (false) Send data synchronously (skips the worker) (optional).
    # @option opts [String]    :tags The comma-separated list of tags (optional).
    # @option opts [Hash]      :context The context to associate with the exception (optional).
    # @option opts [String]    :controller The controller name (such as a Rails controller) (optional).
    # @option opts [String]    :action The action name (such as a Rails controller action) (optional).
    # @option opts [Hash]      :parameters The HTTP request paramaters (optional).
    # @option opts [Hash]      :session The HTTP request session (optional).
    # @option opts [String]    :url The HTTP request URL (optional).
    # @option opts [Exception] :cause The cause for this error (optional).
    #
    # @return [String] UUID reference to the notice within Honeybadger.
    # @return [false] when ignored.
    def record(notice_message, context = {})
      Honeybadger.notify(notice_message, context)
    end
  end
end
