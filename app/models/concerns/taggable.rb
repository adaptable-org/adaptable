# frozen_string_literal: true

require 'active_support/concern'

# Adds logic for intelligently creating a parameterized key from the name attribute
module Taggable
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :activities
    has_and_belongs_to_many :disabilities
  end
end
