class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :units
      t.references :parent, :polymorphic => true

      t.timestamps
    end
  end
end
