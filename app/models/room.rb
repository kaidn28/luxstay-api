class Room < ApplicationRecord
  belongs_to :place, inverse_of: :room
  validates :place, presence: true

  validates :square, presence: true
  validates :num_of_bedroom, :num_of_bed, :num_of_bathroom, :num_of_kitchen,
            presence: true, numericality: {only_integer: true}
end
