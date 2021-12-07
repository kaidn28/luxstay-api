class AddPlaceRefOverviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :overviews, :place, null: false, foreign_key: true
  end
end
