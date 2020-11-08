class AddConstraints < ActiveRecord::Migration[6.1]
  def up
    change_column :disabilities, :key, :string, null: false
    change_column :organizations, :key, :string, null: false

    remove_index :disabilities, :key
    add_index :disabilities, :key, unique: true

    remove_index :organizations, :key
    add_index :organizations, :key, unique: true
  end

  def down
    change_column :disabilities, :key, :string
    change_column :organizations, :key, :string
  end
end
