class BookingFormat < Grape::Entity
  expose :id
  expose :start_date
  expose :end_date
  expose :status
  expose :payment_gateway
  expose :num_of_people
  expose :price
  expose :coupon_code
  expose :user_id
  expose :place_id
end
