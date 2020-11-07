# frozen_string_literal: true

require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "requires primary attributes" do
    org = Organization.new
    assert_not org.valid?
    assert_not_empty org.errors.where(:name)
    assert_not_empty org.errors.where(:url)

    org.name = 'Example'
    org.url = 'https://example.com'
    assert org.valid?
  end

  test "requires unique names/urls" do
    org = Organization.new(name: 'Example', url: 'https://example.com')
    assert org.valid?

    existing_org = organizations(:caf)
    org.name = existing_org.name
    org.url = existing_org.url
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
