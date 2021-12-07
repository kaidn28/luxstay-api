class AddPlaceRefToLocation < ActiveRecord::Migration[6.0]
  def change
    add_reference :locations, :place, null: false, foreign_key: true
  end
end
