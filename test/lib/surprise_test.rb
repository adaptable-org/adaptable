# frozen_string_literal: true

require 'test_helper'

class SurpriseTest < ActiveSupport::TestCase
  test "logs exceptions" do
    refute_nil Surprise.record(StandardError.new)
  end
end
