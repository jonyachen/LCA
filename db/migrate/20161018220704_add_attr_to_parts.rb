class AddAttrToParts < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :title, :string
    add_column :parts, :description, :string
  end
end
