# frozen_string_literal: true

require 'test_helper'

class SurpriseTest < ActiveSupport::TestCase
  test "logs exceptions" do
    refute_nil Surprise.record(StandardError.new)
  end

  test "logs exceptions with options" do
    refute_nil Surprise.record(StandardError.new, { tags: 'test' })
  end
end
