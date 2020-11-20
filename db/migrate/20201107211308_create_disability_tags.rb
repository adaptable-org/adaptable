# frozen_string_literal: true

class CreateDisabilityTags < ActiveRecord::Migration[6.1]
  def change
    create_table :disability_tags do |t|
      t.string :key
      t.string :name
      t.string :description
      t.integer :parent_id

      t.index :key
      t.index :name
      t.index :parent_id

      t.timestamps
    end
  end
end
