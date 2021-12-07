class AddPlaceRefSchedulePrices < ActiveRecord::Migration[6.0]
  def change
    add_reference :schedule_prices, :place, null: false, foreign_key: true
  end
end
