class AddStatusPaymentGatewayToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :status, :integer
    add_column :bookings, :payment_gateway, :integer
    add_column :bookings, :num_of_people, :integer
    add_column :bookings, :price, :float
    add_column :bookings, :coupon_code, :string
  end
end
