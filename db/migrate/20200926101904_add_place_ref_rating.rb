class AddPlaceRefRating < ActiveRecord::Migration[6.0]
  def change
    add_reference :ratings, :place, null: false, foreign_key: true
  end
end
