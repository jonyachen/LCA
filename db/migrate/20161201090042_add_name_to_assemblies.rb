class AddNameToAssemblies < ActiveRecord::Migration[5.0]
  def change
    add_column :assemblies, :name, :string
  end
end
