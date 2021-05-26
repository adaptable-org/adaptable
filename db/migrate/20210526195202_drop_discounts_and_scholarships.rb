class DropDiscountsAndScholarships < ActiveRecord::Migration[6.1]
  def change
    drop_table :scholarships
    drop_table :discounts
  end
end
