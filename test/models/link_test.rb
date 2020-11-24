# frozen_string_literal: true

require "test_helper"

class LinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: links
#
#  id            :bigint           not null, primary key
#  linkable_type :string           not null
#  text          :text
#  type          :integer
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  linkable_id   :bigint           not null
#
# Indexes
#
#  index_links_on_linkable                       (linkable_type,linkable_id)
#  index_links_on_linkable_type_and_linkable_id  (linkable_type,linkable_id)
#
