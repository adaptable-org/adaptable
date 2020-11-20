class AddKeyToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :key, :string

    add_index :organizations, :key
  end
end
