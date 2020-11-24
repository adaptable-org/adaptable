class AddColumnsToDiscounts < ActiveRecord::Migration[6.1]
  def change
    add_column :discounts, :redemption_notes, :text
    add_column :discounts, :percent, :integer
    add_column :discounts, :value_in_cents, :integer
    add_column :discounts, :original_price_in_cents, :integer
    add_column :discounts, :discounted_price_in_cents, :integer
  end
end
