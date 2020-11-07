# frozen_string_literal: true

require "test_helper"

class DisabilityTagTest < ActiveSupport::TestCase
  test "requires primary attributes" do
    tag = DisabilityTag.new
    assert_not tag.valid?
    assert_not_empty tag.errors.where(:key)
    assert_not_empty tag.errors.where(:name)

    tag.key = 'disability'
    tag.name = 'Disability'
    assert tag.valid?
  end

  test "requires unique keys/names" do
    tag = DisabilityTag.new(key: 'disability', name: 'Disability')
    assert tag.valid?

    existing_tag = disability_tags(:amputation)
    tag.key = existing_tag.key
    tag.name = existing_tag.name
    assert_not tag.valid?
    assert_not_empty tag.errors.where(:key)
    assert_not_empty tag.errors.where(:name)
  end
end

# == Schema Information
#
# Table name: disability_tags
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
#  index_disability_tags_on_key        (key)
#  index_disability_tags_on_name       (name)
#  index_disability_tags_on_parent_id  (parent_id)
#
