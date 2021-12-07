class AddBookingsRefHistoryBookings < ActiveRecord::Migration[6.0]
  def change
    add_reference :history_bookings, :booking, null: false, foreign_key: true
  end
end
