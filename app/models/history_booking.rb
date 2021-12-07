class HistoryBooking < ApplicationRecord
  enum status: {pending: 1, paid: 2, canceled: 3, failed: 4}

  belongs_to :booking

  validates :modify_datetime, presence: true
  validates :status, presence: true, inclusion: {in: statuses.keys}
end
