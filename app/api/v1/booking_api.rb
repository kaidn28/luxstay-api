class BookingApi < ApiV1
  namespace :booking do
    before do
      authenticated
    end

    desc "User book a place"
    params do
      requires :start_date, :end_date, type: String, message: I18n.t("messages.errors.required")
      requires :num_of_people, type: Integer, message: I18n.t("messages.errors.required")
      requires :place_id, type: Integer, message: I18n.t("messages.errors.required")
    end
    post "/new" do
      data = valid_params params, Booking::BOOKING_PARAMS
      place = Place.find_by id: params[:place_id]
      data[:start_date] = Date.parse params[:start_date]
      data[:end_date] = Date.parse params[:end_date]
      data[:user_id] = current_user.id
      data[:payment_gateway] = nil
      data[:status] = "pending"
      coupon = Coupon.find_by code_name: params[:coupon_code]
      data[:price] = Booking.charge params[:start_date], params[:end_date], place
      data[:price] = data[:price] * (1 - coupon.discount / 100) if coupon

      booking = Booking.new data

      if booking.valid?
        booking.save

        return render_success_response(:ok, BookingResFormat, {data: booking}, I18n.t("messages.success.booking"))
      end

      error!(booking.errors.full_messages[0], :bad_request)
    end

    desc "Get booking by user"

    params do
      requires :id, type: Integer
    end

    get "/user/:id" do
      bookings = Booking.where user_id: params[:id]
      results = []
      bookings.each do |b|
        result = {}
        place = Place.find_by id: b.place_id
        result[:id] = b.id
        result[:place_id] = b.place_id
        result[:place_name] = place.name
        result[:place_type] = place.place_type
        result[:num_of_guest] = b.num_of_people
        result[:price] = b.price
        result[:checkin] = b.start_date
        result[:checkout] = b.end_date
        results << result 
      end

      return present({data: results}, nil, success: true, message: "success") if results
    end

    desc "Get booking by place"

    params do
      requires :id, type: Integer
    end

    get "/place/:id" do
      bookings = Booking.where place_id: params[:id]

      return render_success_response(:ok, BookingResFormat, {data: bookings}, "success") if bookings

      error!(booking.errors.full_messages[0], :bad_request)
    end

    desc "Get all bookings by host"

    params do
      requires :id, type: Integer
    end

    get "/host/:id" do
      place_id = Place.where(user_id: params[:id]).ids
      results = []

      place_id.each do |id|
        bookings = Booking.where(place_id: id)

        bookings.each do |b|
          result = {}
          result[:id] = Place.find_by(id: b[:place_id]).id
          result[:start_date] = b[:start_date]
          result[:end_date] = b[:end_date]
          result[:num_of_people] = b[:num_of_people]
          result[:price] = b[:price]
          result[:user_id] = b[:user_id]
          result[:place_name] = Place.find_by(id: b[:place_id]).name
          results << result
        end
      end

      return render_success_response(:ok, BookingHostFormat, results, "success") if results

      error!("error", :bad_request)
    end
  end
end
