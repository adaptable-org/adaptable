# frozen_string_literal: true

require "test_helper"

class DiscountTest < ActiveSupport::TestCase
  setup do
    @discount = Discount.new
  end

  test "connected to an offering" do
    assert_respond_to @discount, :offering
  end
end

# == Schema Information
#
# Table name: discounts
#
#  id                        :bigint           not null, primary key
#  discounted_price_in_cents :integer
#  original_price_in_cents   :integer
#  percent                   :integer
#  redemption_notes          :text
#  value_in_cents            :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
