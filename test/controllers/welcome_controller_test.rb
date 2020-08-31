# frozen_string_literal: true

require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "the root url (or home page)" do
    get root_url
    assert_response :success
  end
end
