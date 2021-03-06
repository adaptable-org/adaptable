# frozen_string_literal: true

require "test_helper"

class OfferingTest < ActiveSupport::TestCase
  test "is keyable" do
    assert Offering.new.private_methods.include?(:parameterize_key)
  end

  test "requires primary attributes" do
    offering = Offering.new
    assert_not offering.valid?

    name_errors = offering.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :blank, name_errors.first.type
  end

  test "requires unique keys/names" do
    existing_offering = offerings(:caf_grants)
    new_offering = Offering.new(
      name: existing_offering.name
    )

    assert_not new_offering.valid?

    name_errors = new_offering.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :taken, name_errors.first.type
  end

  test "can be connected to disabilities" do
    offering = offerings(:caf_grants)
    assert_empty offering.disabilities
    offering.disabilities << disabilities(:amputation)
    assert offering.save
    assert_not_empty offering.reload.disabilities
  end

  test "can be connected to activities" do
    offering = offerings(:caf_grants)
    assert_empty offering.activities
    offering.activities << activities(:skiing)
    assert offering.save
    assert_not_empty offering.reload.activities
  end

  test "can be connected to links" do
    offering = offerings(:caf_grants)
    assert_empty offering.links
    offering.links << links(:caf)
    assert offering.save
    assert_not_empty offering.reload.links
  end
end

# == Schema Information
#
# Table name: offerings
#
#  id              :bigint           not null, primary key
#  key             :string
#  name            :string
#  offerable_type  :string
#  summary         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  offerable_id    :integer
#  organization_id :bigint           not null
#
# Indexes
#
#  index_offerings_on_key              (key) UNIQUE
#  index_offerings_on_name             (name)
#  index_offerings_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
