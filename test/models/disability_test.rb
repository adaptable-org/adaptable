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
    grandparent = Disability.create(name: 'Grandparent', key: 'grandparent')
    parent = grandparent.children.create(name: 'Parent', key: 'parent')
    assert_includes grandparent.children, parent

    # disability = disabilities(:amputation)
    # assert_includes disability.children, disabilities(:upper_extremity)
    # assert_includes disability.children, disabilities(:lower_extremity)
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
