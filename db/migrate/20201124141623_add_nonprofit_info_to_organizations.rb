class AddNonprofitInfoToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :nonprofit, :boolean, default: false
    add_column :organizations, :nonprofit_identifier, :string
  end
end
