# frozen_string_literal: true

require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "requires key attributes" do
    org = Organization.new
    assert_not org.valid?
    assert_not_empty org.errors.where(:name)
    assert_not_empty org.errors.where(:url)
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
