class RenameLinksTypeColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :links, :type, :kind
  end
end
