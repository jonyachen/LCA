class AddMaterialToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :material, :string
  end
end
