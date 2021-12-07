class SchedulePrice < ApplicationRecord
  belongs_to :place, inverse_of: :schedule_price
  validates :place, presence: true

  validates :normal_day_price, presence: true, numericality: {greater_than: Settings.validations.place.min_normal_price}
  validates :weekend_price, presence: true, numericality: {greater_than: Settings.validations.place.min_weekend_price}
end
