# frozen_string_literal: true

# Represents financial grants for equipment, coaching, competing, etc.
class Grant < ApplicationRecord
  include Offerable
end

# == Schema Information
#
# Table name: grants
#
#  id                :bigint           not null, primary key
#  application_notes :text
#  eligibility_notes :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
