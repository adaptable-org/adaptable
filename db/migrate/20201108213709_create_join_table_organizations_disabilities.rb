class CreateJoinTableOrganizationsDisabilities < ActiveRecord::Migration[6.1]
  def change
    create_join_table :organizations, :disabilities do |t|
      t.index [:organization_id, :disability_id], name: 'index_disabilities_orgs_on_org_id_and_disability_id'
      t.index [:disability_id, :organization_id], name: 'index_disabilities_orgs_on_disability_id_and_org_id'
    end
  end
end
