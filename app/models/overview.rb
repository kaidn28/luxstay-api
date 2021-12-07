class Overview < ApplicationRecord
  belongs_to :place, inverse_of: :overviews
  validates :place, presence: true

  validates :image, presence: true
end
