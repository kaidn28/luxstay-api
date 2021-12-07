class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.integer :square
      t.integer :num_of_bedroom
      t.integer :num_of_bed
      t.integer :num_of_bathroom
      t.integer :num_of_kitchen
    end
  end
end
