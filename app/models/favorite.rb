class Favorite < ApplicationRecord
  BOOKMARK_PARAMS = %i(place_id).freeze

  belongs_to :user
end
