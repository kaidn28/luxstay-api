class DropLocationsTable < ActiveRecord::Migration[6.0]
  def up
    remove_reference :locations, :place, index: true, foreign_key: true
    drop_table :locations
  end

  def down
    create_table :locations do |t|
      t.text :district
      t.text :town
      t.text :road
      t.text :home_number
      t.timestamps
    end
  end
end
