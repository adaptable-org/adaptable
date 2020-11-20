class CreateJoinTableOfferingsActivities < ActiveRecord::Migration[6.1]
  def change
    create_join_table :offerings, :activities do |t|
      t.index [:offering_id, :activity_id], name: 'index_activities_offers_on_offer_id_and_activity_id'
      t.index [:activity_id, :offering_id], name: 'index_activities_offers_on_activity_id_and_offer_id'
    end
  end
end
