class ApiV1 < Grape::API
  format :json
  prefix :api
  version "v1", using: :path

  mount AuthApi
  mount UserApi
  mount BookingApi
  mount PlaceApi
  mount BookmarkApi
  mount CouponApi
end
