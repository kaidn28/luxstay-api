class PlaceResFormat < Grape::Entity
  expose :data, using: PlaceFormat

  expose :message do |_places, options|
    options[:message]
  end
end
