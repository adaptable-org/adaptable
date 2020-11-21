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

  test "connects a disabilities collection" do
    assert_respond_to @taggable, :disabilities
    assert_empty @taggable.disabilities
  end

  test "connects an activities collection" do
    assert_respond_to @taggable, :activities
    assert_empty @taggable.activities
  end
end
