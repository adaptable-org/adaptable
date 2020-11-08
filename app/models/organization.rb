# frozen_string_literal: true

# Basic model for representing adaptive organizations
class Organization < ApplicationRecord
  include Keyable

  validates :name, uniqueness: true, presence: true
  validates :url, uniqueness: true
end

# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  key        :string
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_key  (key)
#
