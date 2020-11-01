# frozen_string_literal: true

require 'test_helper'

class LandingControllerTest < ActionDispatch::IntegrationTest
  test "the root url (or home page)" do
    get root_url
    assert_response :success
  end

  test "the home page" do
    get home_url
    assert_response :success
  end

  test "the email list confirmation page" do
    get confirm_url
    assert_response :success
  end
end
