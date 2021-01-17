# frozen_string_literal: true

require 'active_support/concern'

# Adds Offerable-specific logic to classes with a delegated type of Offerable
module Offerable
  extend ActiveSupport::Concern

  included do
    has_one :offering, as: :offerable, touch: true
  end
end
