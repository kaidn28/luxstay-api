class DropFacilitiesTable < ActiveRecord::Migration[6.0]
  def up
    remove_reference :facilities, :place, index: true, foreign_key: true
    drop_table :facilities
  end

  def down
    create_table :facilities do |t|
      t.boolean :wifi
      t.boolean :tv
      t.boolean :fan
      t.boolean :air_condition
      t.boolean :fridge
      t.boolean :work_desk
      t.boolean :sofa
      t.boolean :washing_machine
      t.boolean :balcony
      t.boolean :karaoke
      t.boolean :bbq_space
      t.boolean :swimming_pool
      t.timestamps
    end
  end
end
