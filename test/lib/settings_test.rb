# frozen_string_literal: true

require 'test_helper'

class SettingsTest < ActiveSupport::TestCase
  # rubocop:disable Metrics/MethodLength
  def setup
    @default_return_value = 'Default Return Value'
    @secrets = {
      'sekrit_one' => %i[test_one_secret],
      'sekrit_two_three' => %i[test_two_secret test_three_secret]
    }
    @settings = {
      'One' => %i[test_one],
      'Two Three' => %i[test_two test_three],
      'test' => %i[test_erb],
      'Adaptable (Test)' => %i[brand name],
      'Adaptable.org (Test)' => %i[brand domain]
    }
    @env = {
      'example' => %i[example],
      'test' => %i[rails_env]
    }
    @all_values = {}.merge(@secrets, @settings, @env)
  end
  # rubocop:enable Metrics/MethodLength

  test "retrieves .secret values with varying key depths" do
    @secrets.each do |expected_value, keys|
      assert_equal expected_value, Settings.secret(*keys), "failed to match #{keys.inspect} and return #{expected_value} for Settings.secrets"
    end
  end

  test "retrieves .config values with varying key depths" do
    @settings.each do |expected_value, keys|
      assert_equal expected_value, Settings.config(*keys), "failed to match #{keys.inspect} and return #{expected_value} for Settings.config"
    end
  end

  test "retrieves .env values" do
    @env.each do |expected_value, keys|
      assert_equal expected_value, Settings.env(*keys), "failed to match #{keys.inspect} and return #{expected_value} for Settings.env"
    end
  end

  test "performs .optional lookups across all sources with varying key depths" do
    @all_values.each do |expected_value, keys|
      assert_equal expected_value, Settings.optional(*keys), "failed to match #{keys.inspect} and return #{expected_value}"
    end
  end

  test "performs .required lookups across all sources with varying key depths" do
    @all_values.each do |expected_value, keys|
      assert_equal expected_value, Settings.required(*keys), "failed to match #{keys.inspect} and return #{expected_value}"
    end
  end

  test "peforms .default lookups across all sources with varying key depths" do
    @all_values.each do |expected_value, keys|
      assert_equal expected_value, Settings.default(*keys) { @default_return_value }, "failed to match #{keys.inspect} and return #{expected_value}"
    end
  end

  test "discards env.yml values when they have already been set" do
    assert_not_equal 'not_test', Settings.env(:rails_env)
    assert_equal 'test', Rails.env
    assert_equal 'test', ENV['RAILS_ENV']
    assert_equal 'test', Settings.env(:rails_env)
  end

  test "returns the default when a default lookup does not have a match" do
    assert_equal @default_return_value, Settings.default(:this_key_does_not_exist_anywhere) { @default_return_value }
    assert_equal @default_return_value, Settings.default(:test_two_secret, :this_key_does_not_exist_anywhere) { @default_return_value }
    assert_equal @default_return_value, Settings.default(:this_key_does_not_exist_anywhere) { @default_return_value }
    assert_equal @default_return_value, Settings.default(:test_two, :this_key_does_not_exist_anywhere) { @default_return_value }
    assert_equal @default_return_value, Settings.default(:this_key_does_not_exist_anywhere) { @default_return_value }
  end

  test "raises exception when retrieving values using non-symbol params" do
    assert_raises(ArgumentError) { Settings.secret('test_one_secret') }
    assert_raises(ArgumentError) { Settings.secret(:test_one_secret, 'test_three_secret') }
    assert_raises(ArgumentError) { Settings.config('test_one') }
    assert_raises(ArgumentError) { Settings.config(:test_one, 'test_three') }
    assert_raises(ArgumentError) { Settings.env('example') }
    assert_raises(ArgumentError) { Settings.optional('example') }
    assert_raises(ArgumentError) { Settings.required('example') }
    assert_raises(ArgumentError) { Settings.default('example') { @default_return_value } }
  end

  test "raises exception when a broad lookup has multiple matches" do
    assert_raises(Settings::ConflictError) { Settings.optional(:conflict) }
  end

  test "raises exception when a required lookup has no match" do
    assert_raises(Settings::MissingError) { Settings.required(:this_key_does_not_exist_anywhere) }
    assert_raises(Settings::MissingError) { Settings.required(:test_two_secret, :this_key_does_not_exist_anywhere) }
  end

  test "raises exception when a default lookup is used without providing a default block whether a match exists or not" do
    assert_raises(ArgumentError) { Settings.default(:test_one) }
    assert_raises(ArgumentError) { Settings.default(:this_key_does_not_exist_anywhere) }
  end
end
