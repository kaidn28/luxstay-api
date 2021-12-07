class CreateCommonFacilities < ActiveRecord::Migration[6.0]
  def change
    create_table :common_facilities do |t|
      t.boolean :wifi
      t.boolean :tv
      t.boolean :fan
      t.boolean :air_condition
      t.boolean :fridge
      t.boolean :work_desk
      t.boolean :sofa
      t.boolean :washing_machine
    end
  end
end
