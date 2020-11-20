# frozen_string_literal: true

require "test_helper"

class TaggableClass < ActiveRecord::Base
  self.table_name = 'organizations'

  include Taggable
end

class TaggableTest < ActiveSupport::TestCase
  setup do
    @taggable = TaggableClass.new
  end
end
