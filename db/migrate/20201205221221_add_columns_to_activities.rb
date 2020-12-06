class AddColumnsToActivities < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :wikipedia_key, :string
    add_column :activities, :also_known_as, :string
    add_column :activities, :mechanics, :integer
  end
end
