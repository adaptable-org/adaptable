# frozen_string_literal: true

# Represents opportunities to save on products/services due to disability
class Discount < ApplicationRecord
  include Offerable
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
