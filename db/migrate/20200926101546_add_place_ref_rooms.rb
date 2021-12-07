class AddPlaceRefRooms < ActiveRecord::Migration[6.0]
  def change
    add_reference :rooms, :place, null: false, foreign_key: true
  end
end
