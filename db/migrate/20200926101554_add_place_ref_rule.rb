class AddPlaceRefRule < ActiveRecord::Migration[6.0]
  def change
    add_reference :rules, :place, null: false, foreign_key: true
  end
end
