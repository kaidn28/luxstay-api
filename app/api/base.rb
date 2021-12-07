class Base < Grape::API
  helpers AuthHelper
  helpers ResponseHelper
  helpers ParamHelper
  helpers UserHelper
  helpers RecommenderHelper
  mount ApiV1
end
