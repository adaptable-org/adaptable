class AddColumnsToGrants < ActiveRecord::Migration[6.1]
  def change
    add_column :grants, :eligibility_notes, :text
    add_column :grants, :application_notes, :text
  end
end
