# frozen_string_literal: true

# Activity tag for organizing resources by activity
class Activity < ApplicationRecord
  include Keyable

  has_closure_tree

  has_and_belongs_to_many :organizations

  validates :name, uniqueness: true, presence: true
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
