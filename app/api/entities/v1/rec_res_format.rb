class RecResFormat < Grape::Entity
    expose :data, using: RecFormat
  
    expose :message do |_places, options|
      options[:message]
    end
  end
  