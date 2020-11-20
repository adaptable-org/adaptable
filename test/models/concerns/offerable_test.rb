# frozen_string_literal: true

require "test_helper"

class OfferableClass < ActiveRecord::Base
  self.table_name = 'discounts'

  include Offerable
end

class OfferableTest < ActiveSupport::TestCase
  setup do
    @offerable = OfferableClass.new
  end
end
