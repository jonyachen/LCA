class CreateAssemblies < ActiveRecord::Migration[5.0]
  def change
    create_table :assemblies do |t|
      t.integer :user_id
      t.text :components
      t.text :components_json

      t.timestamps
    end
  end
end
