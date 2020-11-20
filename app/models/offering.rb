# frozen_string_literal: true

# Base delegated type model for organization offerings
class Offering < ApplicationRecord
  include Keyable, Taggable

  delegated_type :offerable, types: %w[Grant Scholarship Discount]

  belongs_to :organization
end

# == Schema Information
#
# Table name: offerings
#
#  id              :bigint           not null, primary key
#  key             :string
#  name            :string
#  offerable_type  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  offerable_id    :integer
#  organization_id :bigint           not null
#
# Indexes
#
#  index_offerings_on_key              (key) UNIQUE
#  index_offerings_on_name             (name)
#  index_offerings_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
