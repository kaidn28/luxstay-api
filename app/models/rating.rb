class Rating < ApplicationRecord
  RATING_PARAMS = %i(id score comment).freeze

  belongs_to :user
  belongs_to :place
end
