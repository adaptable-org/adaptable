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

    def parameterize_key
      self.key ||= name if name.present?
      self.key = key&.parameterize
    end
end
