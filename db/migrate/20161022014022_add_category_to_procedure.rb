class AddCategoryToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :category, :string
  end
end
