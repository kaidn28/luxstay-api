class BookingResFormat < Grape::Entity
  expose :data, using: BookingFormat

  expose :message do |_bookings, options|
    options[:message]
  end
end
