class CreateFacilitiesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities do |t|
      t.string :name
    end
  end
end
