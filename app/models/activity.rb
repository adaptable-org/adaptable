# frozen_string_literal: true

# Activity tag for organizing resources by activity
class Activity < ApplicationRecord
  include Keyable

  has_closure_tree

  has_and_belongs_to_many :organizations

  enum mechanics: {
    bicycle: 1,
    hand_cycle: 2,
    sled: 3,
    sit_ski: 4,
    sitting: 5,
    standing: 6,
    stationary: 7,
    wheelchair: 8,
    powered_wheelchair: 9
  }

  validates :name, uniqueness: true, presence: true
end

# == Schema Information
#
# Table name: activities
#
#  id            :bigint           not null, primary key
#  also_known_as :string
#  key           :string           not null
#  mechanics     :integer
#  name          :string
#  wikipedia_key :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :integer
#
# Indexes
#
#  index_activities_on_key        (key) UNIQUE
#  index_activities_on_name       (name)
#  index_activities_on_parent_id  (parent_id)
#
