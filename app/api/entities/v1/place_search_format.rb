class PlaceSearchFormat < Grape::Entity
    expose :data do
        expose :data, using: PlaceFormat
        expose :count
    end

    expose :message do |_places, options|
        options[:message]
    end
end
  