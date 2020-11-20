class RenameDisabilityTagTables < ActiveRecord::Migration[6.1]
  def change
    rename_table :disability_tags, :disabilities
    rename_table :disability_tag_hierarchies, :disability_hierarchies

    rename_index :disability_hierarchies, 'disability_tag_desc_idx', 'disability_desc_idx'
    rename_index :disability_hierarchies, 'disability_tag_anc_desc_idx', 'disability_anc_desc_idx'
  end
end
