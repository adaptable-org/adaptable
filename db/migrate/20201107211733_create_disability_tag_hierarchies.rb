# frozen_string_literal: true

class CreateDisabilityTagHierarchies < ActiveRecord::Migration[6.1]
  def change
    create_table :disability_tag_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :disability_tag_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "disability_tag_anc_desc_idx"

    add_index :disability_tag_hierarchies, [:descendant_id],
      name: "disability_tag_desc_idx"
  end
end
