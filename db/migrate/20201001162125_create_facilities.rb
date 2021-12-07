class CreateFacilities < ActiveRecord::Migration[6.0]
  def change
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
    add_reference :facilities, :place, null: false, foreign_key: true
  end
end
