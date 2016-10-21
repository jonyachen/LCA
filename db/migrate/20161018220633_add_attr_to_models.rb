class AddAttrToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :models, :title, :string
    add_column :models, :description, :string
  end
end
