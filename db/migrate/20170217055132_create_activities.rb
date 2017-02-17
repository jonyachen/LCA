class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :path
      t.string :units
      t.float :impact_per_unit
      t.float :uncertainty_lower
      t.float :uncertainty_upper

      t.timestamps
    end
  end
end
