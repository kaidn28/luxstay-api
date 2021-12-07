class DropSpecialFacilitiesTable < ActiveRecord::Migration[6.0]
  def up
    remove_reference :special_facilities, :place, index: true, foreign_key: true
    drop_table :special_facilities
  end

  def down
    create_table :special_facilities do |t|
      t.boolean :balcony
      t.boolean :karaoke
      t.boolean :bbq_space
      t.boolean :swimming_pool
      t.timestamps
    end
  end
end
