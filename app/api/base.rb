class Base < Grape::API
  helpers AuthHelper
  helpers ResponseHelper
  helpers ParamHelper
  helpers UserHelper
  helpers RecommenderHelper
  helpers PlaceHelper
  mount ApiV1
end
