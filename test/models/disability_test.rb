# frozen_string_literal: true

require "test_helper"

class DisabilityTest < ActiveSupport::TestCase
  test "generates a parameterized key from the name if a key isn't provided" do
    disability = Disability.new(name: 'Example Disability')
    assert_nil disability.key
    assert disability.valid?
    assert_equal 'example-disability', disability.key
  end

  test "does not generate a key from the name if key has a value" do
    disability_key = 'different-key'
    disability = Disability.new(name: 'Example Disability', key: disability_key)
    assert disability.valid?
    assert_equal disability_key, disability.key
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
#  key         :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :integer
#
# Indexes
#
#  index_disabilities_on_key        (key)
#  index_disabilities_on_name       (name)
#  index_disabilities_on_parent_id  (parent_id)
#
