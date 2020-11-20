# frozen_string_literal: true

require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "is keyable" do
    assert Activity.new.private_methods.include?(:parameterize_key)
  end

  test "requires primary attributes" do
    activity = Activity.new
    assert_not activity.valid?

    name_errors = activity.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :blank, name_errors.first.type
  end

  test "requires unique keys/names" do
    existing_activity = activities(:skiing)
    new_activity = Activity.new(
      name: existing_activity.name,
      key: existing_activity.key
    )

    assert_not new_activity.valid?

    name_errors = new_activity.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :taken, name_errors.first.type

    key_errors = new_activity.errors.where(:key)
    assert_not_empty key_errors
    assert_equal :taken, key_errors.first.type
  end

  test "can be connected to organizations" do
    activity = activities(:skiing)
    assert_empty activity.organizations
    activity.organizations << organizations(:adaptive_sports_cb)
    assert activity.save
    assert_not_empty activity.reload.organizations
  end

  test "suports tag hierarchies" do
    Activity.rebuild!

    skiing = activities(:skiing)
    sit_skiing = activities(:sit_skiing)
    alpine_sit_skiing = activities(:alpine_sit_skiing)
    nordic_sit_skiing = activities(:nordic_sit_skiing)

    assert_includes skiing.children, sit_skiing
    assert_includes skiing.leaves, nordic_sit_skiing
    assert_equal sit_skiing.parent, skiing

    assert_includes sit_skiing.children, nordic_sit_skiing
    assert_equal nordic_sit_skiing.parent, sit_skiing

    assert_includes nordic_sit_skiing.siblings, alpine_sit_skiing
  end
end

# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  key        :string           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
# Indexes
#
#  index_activities_on_key        (key) UNIQUE
#  index_activities_on_name       (name)
#  index_activities_on_parent_id  (parent_id)
#
