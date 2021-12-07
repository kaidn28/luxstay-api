class BookmarkResFormat < Grape::Entity
  expose :data, using: BookmarkFormat

  expose :message do |_bookings, options|
    options[:message]
  end
end
