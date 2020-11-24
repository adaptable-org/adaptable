class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.text :text
      t.text :url
      t.references :linkable, polymorphic: true, null: false
      t.integer :type

      t.timestamps
    end

    add_index :links, [:linkable_type, :linkable_id]
  end
end
