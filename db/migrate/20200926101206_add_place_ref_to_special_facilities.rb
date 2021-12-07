class AddPlaceRefToSpecialFacilities < ActiveRecord::Migration[6.0]
  def change
    add_reference :special_facilities, :place, null: false, foreign_key: true
  end
end
