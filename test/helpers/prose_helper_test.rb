# frozen_string_literal: true

require 'test_helper'

class ProseHelperTest < ActionView::TestCase
  test "markdown rendering" do
    assert_equal "<p><strong>Bold</strong></p>\n", markdown('**Bold**')
  end
end
