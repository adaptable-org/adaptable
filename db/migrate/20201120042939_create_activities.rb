class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :key, null: false
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :activities, :key, unique: true
    add_index :activities, :name
    add_index :activities, :parent_id
  end
end
