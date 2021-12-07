class CreatePlaceFacilitiesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :place_facilities do |t|
    end
    add_reference :place_facilities, :place, null: false, foreign_key: true
    add_reference :place_facilities, :facility, null: false, foreign_key: true
  end
end
