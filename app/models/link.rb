# frozen_string_literal: true

# For links related to organizations and offerings
class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  enum kind: %i[apply buy donate home learn volunteer]
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
