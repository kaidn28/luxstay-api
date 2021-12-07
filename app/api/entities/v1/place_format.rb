class PlaceFormat < Grape::Entity
  expose :id
  expose :name
  expose :details
  expose :host, using: UserFormat
  expose :image
  expose :address
  expose :place_type
  expose :schedule_price_attributes
  expose :policy_attributes
  expose :overviews_attributes
  expose :rule_attributes
  expose :room_attributes
  expose :ratings
  expose :place_facilities_attributes
end
