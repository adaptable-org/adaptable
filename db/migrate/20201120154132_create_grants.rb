class CreateGrants < ActiveRecord::Migration[6.1]
  def change
    create_table :grants do |t|

      t.timestamps
    end
  end
end
