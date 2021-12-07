class AddCityToPlace < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :city, :integer
  end
end
