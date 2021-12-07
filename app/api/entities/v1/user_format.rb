class UserFormat < Grape::Entity
  expose :id
  expose :name
  expose :email
  expose :phone
  expose :address
  expose :gender
  expose :birthday
  expose :avatar
end
