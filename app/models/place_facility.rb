class PlaceFacility < ApplicationRecord
  belongs_to :place, inverse_of: :place_facilities
  belongs_to :facility

  validates :place, presence: true
end
