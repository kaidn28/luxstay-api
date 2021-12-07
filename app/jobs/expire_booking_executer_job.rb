class ExpireBookingExecuterJob < ApplicationJob
  queue_as :default

  def perform item
    item.update status: Settings.enum.booking.status.incomplete if item.pending?
  end
end
