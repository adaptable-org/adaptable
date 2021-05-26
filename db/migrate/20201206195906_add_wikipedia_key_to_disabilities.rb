class AddWikipediaKeyToDisabilities < ActiveRecord::Migration[6.1]
  def change
    add_column :disabilities, :wikipedia_key, :string
  end
end
