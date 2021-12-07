class Base < Grape::API
  helpers AuthHelper
  helpers ResponseHelper
  helpers ParamHelper
  helpers UserHelper

  mount ApiV1
end
