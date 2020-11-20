class CreateScholarships < ActiveRecord::Migration[6.1]
  def change
    create_table :scholarships do |t|

      t.timestamps
    end
  end
end
