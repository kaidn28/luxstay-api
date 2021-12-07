class Facility < ApplicationRecord
  has_many :place_facilities, dependent: :destroy

  validates :name, presence: true
end
