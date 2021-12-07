class RatingFormat < Grape::Entity
  expose :id
  expose :user_name
  expose :user_avatar
  expose :place_id
  expose :score
  expose :comment
end
