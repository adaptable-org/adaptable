# frozen_string_literal: true

require "test_helper"

class ScholarshipTest < ActiveSupport::TestCase
  setup do
    @scholarship = Scholarship.new
  end

  test "connected to an offering" do
    assert_respond_to @scholarship, :offering
  end
end

# == Schema Information
#
# Table name: scholarships
#
#  id                :bigint           not null, primary key
#  application_notes :text
#  eligibility_notes :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
