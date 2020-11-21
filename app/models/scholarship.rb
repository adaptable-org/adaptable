# frozen_string_literal: true

# Represents savings or financial assistance for ongoing education/training
class Scholarship < ApplicationRecord
  include Offerable
end

# == Schema Information
#
# Table name: scholarships
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
