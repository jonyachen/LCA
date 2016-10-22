class AddCategoryToMaterials < ActiveRecord::Migration[5.0]
  def change
    add_column :materials, :category, :string
  end
end
