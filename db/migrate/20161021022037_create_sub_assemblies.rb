class CreateSubAssemblies < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_assemblies do |t|
      t.string :title

      t.timestamps
    end
  end
end
