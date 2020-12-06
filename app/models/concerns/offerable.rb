# frozen_string_literal: true

require 'active_support/concern'

# Adds logic for intelligently creating a parameterized key from the name attribute
module Offerable
  extend ActiveSupport::Concern

  included do
    has_one :offering, as: :offerable, touch: true
    has_many :links, as: :linkable
  end
end
