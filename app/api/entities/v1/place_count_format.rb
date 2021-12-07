class PlaceCountFormat < Grape::Entity
  expose :data

  expose :message do |_places, options|
    options[:message]
  end
end
