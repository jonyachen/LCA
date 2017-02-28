class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string :unit
      t.float :conversion_to_si

      t.timestamps
    end
  end
end
