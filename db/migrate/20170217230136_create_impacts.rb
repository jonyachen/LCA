class CreateImpacts < ActiveRecord::Migration[5.0]
  def change
    create_table :impacts do |t|
      t.float :impact_per_unit
      t.float :uncertainty_lower
      t.float :uncertainty_upper
      t.integer :activity_id

      t.timestamps
    end
  end
end
