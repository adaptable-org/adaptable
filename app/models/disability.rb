# frozen_string_literal: true

# Disability tag for organizing resources by disability
class Disability < ApplicationRecord
  include Keyable

  has_closure_tree

  has_and_belongs_to_many :organizations

  validates :name, uniqueness: true, presence: true
end

# == Schema Information
#
# Table name: disabilities
#
#  id            :bigint           not null, primary key
#  description   :string
#  key           :string           not null
#  name          :string
#  wikipedia_key :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :integer
#
# Indexes
#
#  index_disabilities_on_key        (key) UNIQUE
#  index_disabilities_on_name       (name)
#  index_disabilities_on_parent_id  (parent_id)
#
