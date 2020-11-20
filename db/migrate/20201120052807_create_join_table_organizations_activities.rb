class CreateJoinTableOrganizationsActivities < ActiveRecord::Migration[6.1]
  def change
    create_join_table :organizations, :activities do |t|
      t.index [:organization_id, :activity_id], name: 'index_activities_orgs_on_org_id_and_activity_id'
      t.index [:activity_id, :organization_id], name: 'index_activities_orgs_on_activity_id_and_org_id'
    end
  end
end
