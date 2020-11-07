# frozen_string_literal: true

# Disability tag for organizing resources by disability
class DisabilityTag < ApplicationRecord
  has_closure_tree
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
