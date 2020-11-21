# frozen_string_literal: true

require 'active_support/concern'

# Adds logic for intelligently creating a parameterized key from the name attribute
module Keyable
  extend ActiveSupport::Concern

  included do
    before_validation :parameterize_key
    validates :key, uniqueness: true
  end

  private

    # Ensures there is a parameterized value in the key attribute
    #
    # - When name is present, but key isn't, parameterize the name as key
    # - When key is present, ensure it's parameterized
    #
    # @api private
    #
    # @return [String] parameterized key
    def parameterize_key
      self.key ||= name
      self.key = self.key&.parameterize
    end
end
