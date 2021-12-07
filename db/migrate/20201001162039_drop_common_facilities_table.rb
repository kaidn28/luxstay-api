class DropCommonFacilitiesTable < ActiveRecord::Migration[6.0]
  def up
    remove_reference :common_facilities, :place, index: true, foreign_key: true
    drop_table :common_facilities
  end

  def down
    create_table :common_facilities do |t|
      t.boolean :wifi
      t.boolean :tv
      t.boolean :fan
      t.boolean :air_condition
      t.boolean :fridge
      t.boolean :work_desk
      t.boolean :sofa
      t.boolean :washing_machine
      t.timestamps
    end
  end
end
