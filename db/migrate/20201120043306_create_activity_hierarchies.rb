class CreateActivityHierarchies < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :activity_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "activity_anc_desc_idx"

    add_index :activity_hierarchies, [:descendant_id],
      name: "activity_desc_idx"
  end
end
