class AddSummaryToOfferings < ActiveRecord::Migration[6.1]
  def change
    add_column :offerings, :summary, :text
  end
end
