# frozen_string_literal: true

require "test_helper"

class KeyableClass < ActiveRecord::Base
  self.table_name = 'organizations'

  include Keyable

  attr_accessor :name, :key
end

class KeyableTest < ActiveSupport::TestCase
  setup do
    @name = 'Example Test Name'
    @keyable = KeyableClass.new(name: @name)
  end

  test "it auto-generates a key from name if key is blank" do
    assert @keyable.valid?
    assert_equal @name.parameterize, @keyable.key
  end

  test "it does not touch the key if it is not blank" do
    key = 'a-different-key'
    @keyable.key = key

    assert @keyable.valid?
    assert_equal key, @keyable.key
  end

  test "it parameterizes the key value if it is present" do
    key = 'Unparameterized Key'
    @keyable.key = key

    assert @keyable.valid?
    assert_equal key.parameterize, @keyable.key
  end

  test "it gracefully continues if no key value is present" do
    @keyable.name = nil
    @keyable.key = nil

    refute @keyable.valid?
    assert_nil @keyable.key
  end
end
