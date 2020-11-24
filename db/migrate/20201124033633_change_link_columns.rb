class ChangeLinkColumns < ActiveRecord::Migration[6.1]
  def change
    change_column :links, :text, :string
    change_column :links, :url, :string
  end
end
