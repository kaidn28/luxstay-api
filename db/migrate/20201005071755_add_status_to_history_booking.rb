class AddStatusToHistoryBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :history_bookings, :status, :integer
  end
end
