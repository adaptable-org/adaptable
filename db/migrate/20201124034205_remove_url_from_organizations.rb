class RemoveUrlFromOrganizations < ActiveRecord::Migration[6.1]
  def change
    remove_column :organizations, :url
  end
end
