class AddColumnsToScholarships < ActiveRecord::Migration[6.1]
  def change
    add_column :scholarships, :eligibility_notes, :text
    add_column :scholarships, :application_notes, :text
  end
end
