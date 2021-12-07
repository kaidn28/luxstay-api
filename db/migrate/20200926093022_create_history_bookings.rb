class CreateHistoryBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :history_bookings do |t|
      t.datetime :modify_datetime
    end
  end
end
