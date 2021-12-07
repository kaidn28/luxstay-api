class Booking < ApplicationRecord
  BOOKING_PARAMS = %i(start_date end_date num_of_people place_id).freeze

  after_commit :log_history, on: %i(create update)

  enum status: {pending: 1, paid: 2, canceled: 3, incomplete: 4}
  enum payment_gateway: {paypal: 1}

  belongs_to :user
  belongs_to :place
  has_many :history_bookings, dependent: :destroy

  delegate :name, :email, :phone, to: :user, prefix: :renter

  validates :start_date, :end_date, presence: true, availability: true
  validate :end_date_after_start_date
  validates :price, presence: true
  validates :num_of_people, presence: true,
            numericality: {only_integer: true,
                           less_than_or_equal_to: :maximum_people}
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :payment_gateway, presence: true, inclusion: {in: payment_gateways.keys}, allow_nil: true
  validates :coupon_code, presence: true, allow_nil: true

  class << self
    def charge start_date, end_date, place
      total_date = end_date.to_date - start_date.to_date + 1
      range_date = (start_date.to_date..end_date.to_date)
      num_of_weekdays = range_date.select{|d| (1..5).include?(d.wday)}.size
      num_of_weekend =  total_date - num_of_weekdays

      total_price = place.normal_day_price * num_of_weekdays + place.weekend_price * num_of_weekend
      total_price
    end
  end

  def log_history
    history_booking = history_bookings.build(
      status: status,
      modify_datetime: Time.zone.now
    )
    history_booking&.save
  end

  private

  def maximum_people
    place.maximum_rental_people
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:start_date, "cannot be in the past") if start_date.to_date < Time.zone.today
    errors.add(:end_date, "must be after the start date") if end_date.to_i <= start_date.to_i
  end
end
