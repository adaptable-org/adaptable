# frozen_string_literal: true

# Disability tag for organizing resources by disability
class Disability < ApplicationRecord
  has_closure_tree

  validates :key, uniqueness: true
  validates :name, uniqueness: true, presence: true

  before_validation :generate_key

  private

    def generate_key
      return unless name.present? && key.blank?

      self.key = name.parameterize
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
