# frozen_string_literal: true

require "test_helper"

class DisabilityTest < ActiveSupport::TestCase
  test "requires primary attributes" do
    disability = Disability.new
    assert_not disability.valid?
    assert_not_empty disability.errors.where(:key)
    assert_not_empty disability.errors.where(:name)

    disability.key = 'disability'
    disability.name = 'Disability'
    assert disability.valid?
  end

  test "requires unique keys/names" do
    disability = Disability.new(key: 'disability', name: 'Disability')
    assert disability.valid?

    existing_disability = disabilities(:amputation)
    disability.key = existing_disability.key
    disability.name = existing_disability.name
    assert_not disability.valid?
    assert_not_empty disability.errors.where(:key)
    assert_not_empty disability.errors.where(:name)
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
