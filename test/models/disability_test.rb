# frozen_string_literal: true

require "test_helper"

class DisabilityTest < ActiveSupport::TestCase
  test "is keyable" do
    assert Disability.new.private_methods.include?(:parameterize_key)
  end

  test "requires primary attributes" do
    disability = Disability.new
    assert_not disability.valid?

    name_errors = disability.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :blank, name_errors.first.type
  end

  test "requires unique keys/names" do
    existing_disability = disabilities(:amputation)
    new_disability = Disability.new(
      name: existing_disability.name,
      key: existing_disability.key
    )

    assert_not new_disability.valid?

    name_errors = new_disability.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :taken, name_errors.first.type

    key_errors = new_disability.errors.where(:key)
    assert_not_empty key_errors
    assert_equal :taken, key_errors.first.type
  end

  test "can be connected to organizations" do
    disability = disabilities(:amputation)
    assert_empty disability.organizations
    disability.organizations << organizations(:adaptive_sports_cb)
    assert disability.save
    assert_not_empty disability.reload.organizations
  end

  test "suports tag hierarchies" do
    Disability.rebuild!

    amputation = disabilities(:amputation)
    lower_extremity = disabilities(:lower_extremity)
    below_knee_amputation = disabilities(:below_knee_amputation)
    above_knee_amputation = disabilities(:above_knee_amputation)

    assert_includes amputation.children, lower_extremity
    assert_includes amputation.leaves, below_knee_amputation
    assert_equal lower_extremity.parent, amputation

    assert_includes lower_extremity.children, below_knee_amputation
    assert_equal below_knee_amputation.parent, lower_extremity

    assert_includes below_knee_amputation.siblings, above_knee_amputation
  end
end

# == Schema Information
#
# Table name: disabilities
#
#  id          :bigint           not null, primary key
#  description :string
#  key         :string           not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :integer
#
# Indexes
#
#  index_disabilities_on_key        (key) UNIQUE
#  index_disabilities_on_name       (name)
#  index_disabilities_on_parent_id  (parent_id)
#
