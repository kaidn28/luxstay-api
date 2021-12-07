class BookingHostFormat < Grape::Entity
  expose :id
  expose :start_date
  expose :end_date
  expose :num_of_people
  expose :price
  expose :user_id
  expose :place_name
end
