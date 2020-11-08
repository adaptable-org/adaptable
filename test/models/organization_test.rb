# frozen_string_literal: true

require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "requires primary attributes" do
    org = Organization.new
    assert_not org.valid?
    assert_not_empty org.errors.where(:name)
    assert_not_empty org.errors.where(:url)

    name_errors = org.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :blank, name_errors.first.type

    url_errors = org.errors.where(:url)
    assert_not_empty url_errors
    assert_equal :blank, url_errors.first.type
  end

  test "requires unique names/urls" do
    existing_org = organizations(:caf)
    new_org = Organization.new(
      name: existing_org.name,
      url: existing_org.url
    )

    assert_not new_org.valid?

    name_errors = new_org.errors.where(:name)
    assert_not_empty name_errors
    assert_equal :taken, name_errors.first.type

    url_errors = new_org.errors.where(:url)
    assert_not_empty url_errors
    assert_equal :taken, url_errors.first.type
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
