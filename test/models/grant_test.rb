# frozen_string_literal: true

require "test_helper"

class GrantTest < ActiveSupport::TestCase
  setup do
    @grant = Grant.new
  end

  test "connected to an offering" do
    assert_respond_to @grant, :offering
  end
end

# == Schema Information
#
# Table name: grants
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
