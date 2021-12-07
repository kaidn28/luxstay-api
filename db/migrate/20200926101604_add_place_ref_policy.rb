class AddPlaceRefPolicy < ActiveRecord::Migration[6.0]
  def change
    add_reference :policies, :place, null: false, foreign_key: true
  end
end
