class CreateSchedulePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_prices do |t|
      t.float :normal_day_price
      t.float :weekend_price
      t.float :cleaning_price
    end
  end
end
