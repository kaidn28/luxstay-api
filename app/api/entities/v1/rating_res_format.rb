class RatingResFormat < Grape::Entity
  expose :data, using: RatingFormat

  expose :message do |_ratings, options|
    options[:message]
  end
end
