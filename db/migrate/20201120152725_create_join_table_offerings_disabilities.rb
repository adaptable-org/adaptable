class CreateJoinTableOfferingsDisabilities < ActiveRecord::Migration[6.1]
  def change
    create_join_table :offerings, :disabilities do |t|
      t.index [:offering_id, :disability_id], name: 'index_disabilities_offers_on_offer_id_and_disability_id'
      t.index [:disability_id, :offering_id], name: 'index_disabilities_offers_on_disability_id_and_offer_id'
    end
  end
end
