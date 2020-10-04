# frozen_string_literal: true

require 'test_helper'

class ProseControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get about_page_url
    assert_response :success
  end

  test "should get privacy" do
    get privacy_page_url
    assert_response :success
  end

  test "should get terms" do
    get terms_page_url
    assert_response :success
  end

  test "should get security" do
    get security_page_url
    assert_response :success
  end

  test "should get accessibility" do
    get accessibility_page_url
    assert_response :success
  end

  test "should get contact" do
    get contact_page_url
    assert_response :success
  end
end
