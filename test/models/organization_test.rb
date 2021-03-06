# frozen_string_literal: true

require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "is keyable" do
    assert Organization.new.private_methods.include?(:parameterize_key)
  end

  test "requires primary attributes" do
    org = Organization.new
    assert_not org.valid?

    name_errors = org.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :blank, name_errors.first.type
  end

  test "requires unique keys/names" do
    existing_org = organizations(:caf)
    new_org = Organization.new(name: existing_org.name)

    assert_not new_org.valid?

    name_errors = new_org.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :taken, name_errors.first.type
  end

  test "can be connected to disabilities" do
    org = organizations(:adaptive_sports_cb)
    assert_empty org.disabilities
    org.disabilities << disabilities(:amputation)
    assert org.save
    assert_not_empty org.reload.disabilities
  end

  test "can be connected to activities" do
    org = organizations(:adaptive_sports_cb)
    assert_empty org.activities
    org.activities << activities(:skiing)
    assert org.save
    assert_not_empty org.reload.activities
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id                   :bigint           not null, primary key
#  key                  :string           not null
#  name                 :string
#  nonprofit            :boolean          default(FALSE)
#  nonprofit_identifier :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_organizations_on_key  (key) UNIQUE
#
