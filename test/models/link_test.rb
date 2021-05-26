# frozen_string_literal: true

require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "can be associated with organizations" do
    org = organizations(:adaptive_sports_cb)
    link = links(:adaptive_sports_cb_home)
    assert_equal link.linkable, org
  end

  test "can be associated with grants" do
    grant = grants(:caf_grants)
    link = links(:caf_grants)
    assert_equal link.linkable, grant
  end
end

# == Schema Information
#
# Table name: links
#
#  id            :bigint           not null, primary key
#  kind          :integer
#  linkable_type :string           not null
#  text          :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  linkable_id   :bigint           not null
#
# Indexes
#
#  index_links_on_linkable                       (linkable_type,linkable_id)
#  index_links_on_linkable_type_and_linkable_id  (linkable_type,linkable_id)
#
