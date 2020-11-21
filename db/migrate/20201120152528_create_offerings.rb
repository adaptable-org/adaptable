class CreateOfferings < ActiveRecord::Migration[6.1]
  def change
    create_table :offerings do |t|
      t.string :key
      t.string :name
      t.references :organization, null: false, foreign_key: true
      t.string :offerable_type
      t.integer :offerable_id

      t.timestamps
    end
    add_index :offerings, :key, unique: true
    add_index :offerings, :name
  end
end
