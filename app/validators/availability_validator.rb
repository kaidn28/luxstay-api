class AvailabilityValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    bookings = Booking.where("place_id = ?", record.place_id)
    date_ranges = bookings.map{|b| b.start_date..b.end_date}
    date_ranges.each do |range|
      record.errors.add(attribute, "not available") if range.include? value
    end
  end
end
