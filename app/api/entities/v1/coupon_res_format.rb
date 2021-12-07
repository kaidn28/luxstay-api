class CouponResFormat < Grape::Entity
  expose :data, using: CouponFormat

  expose :message do |_ratings, options|
    options[:message]
  end
end
