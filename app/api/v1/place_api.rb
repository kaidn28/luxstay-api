class PlaceApi < ApiV1
  namespace :place do
    desc "Add a place"
    params do
      requires :name, :details, :address, type: String, message: I18n.t("messages.errors.required")
      requires :city, type: Symbol, values: [:hanoi, :hcm, :danang, :nhatrang, :dalat, :quangninh, :hoian, :vungtau]
      requires :place_type, type: Symbol, values: [:homestay, :villa, :apartment, :penhouse, :hostel, :motel]
      requires :overviews_attributes, type: Array, message: I18n.t("messages.errors.required")
      requires :policy_attributes, type: Hash do
        requires :currency, type: Symbol, values: [:vnd, :usd, :yen]
        requires :cancel_policy, type: Symbol, values: [:normal, :flexible, :strict]
        requires :max_num_of_people, type: Integer
      end

      requires :rule_attributes, type: Hash do
        requires :special_rules, type: String
        requires :smoking, :pet, :cooking, :party, type: Symbol, values: [:allowed, :unallowed, :charge]
      end

      requires :room_attributes, type: Hash do
        requires :square, type: Integer
        requires :num_of_bedroom, :num_of_bed, :num_of_bathroom, :num_of_kitchen, type: Integer
      end

      requires :schedule_price_attributes, type: Hash do
        requires :normal_day_price, :weekend_price, :cleaning_price, type: Float
      end

      requires :place_facilities_attributes, type: Array
    end
    post "/new" do
      authenticated

      data = valid_params params, Place::PLACE_PARAMS
      data[:user_id] = current_user.id
      data[:name] = params[:name]
      data[:details] = params[:details]
      data[:city] = params[:city]
      data[:place_type] = params[:place_type]
      data[:image] = params[:image]
      data[:address] = params[:address]
      data[:overviews_attributes] = params[:overviews_attributes]
      data[:policy_attributes] = params[:policy_attributes]
      data[:rule_attributes] = params[:rule_attributes]
      data[:room_attributes] = params[:room_attributes]
      data[:schedule_price_attributes] = params[:schedule_price_attributes]
      data[:place_facilities_attributes] = params[:place_facilities_attributes]
      data[:accepted] = false

      place = Place.new data

      if place.valid?
        place.save

        data[:id] = place.id
        data[:host] = User.find_by id: place.user_id

        return render_success_response(:ok, PlaceResFormat, {data: data}, I18n.t("messages.success.place.create"))
      end

      error!(place.errors.full_messages[0], :bad_request)
    end

    desc "Get place by user_id"

    params do
      requires :user_id, type: Integer
    end

    get "/host/:user_id" do
      places = Place.where(user_id: params[:user_id])

      error!(places.errors.full_messages[0], :bad_request) unless places

      results = []
      places.each do |place|
        result = {}
        result[:name] = place.name
        result[:id] = place.id
        result[:details] = place.details
        result[:address] = place.address
        result[:image] = place.image
        result[:place_type] = place.place_type
        result[:host] = User.find_by id: place.user_id
        result[:overviews_attributes] = place.overviews
        result[:schedule_price_attributes] = place.schedule_price
        result[:room_attributes] = place.room
        result[:policy_attributes] = place.policy
        result[:rule_attributes] = place.rule
        result[:ratings] = place.ratings
        facility = []
        PlaceFacility.where(place_id: place.id).each do |f|
          facility << Facility.find_by(id: f.facility_id).name
        end

        result[:place_facilities_attributes] = facility
        results << result
      end

      return render_success_response(:ok, PlaceResFormat, {data: results}, "success")
    end

    desc "get place by id"

    get "/:place_id" do
      place = Place.find_by id: params[:place_id]

      result = {}
      result[:name] = place.name
      result[:id] = place.id
      result[:details] = place.details
      result[:address] = place.address
      result[:image] = place.image
      result[:place_type] = place.place_type
      result[:host] = User.find_by id: place.user_id
      result[:overviews_attributes] = place.overviews
      result[:schedule_price_attributes] = place.schedule_price
      result[:room_attributes] = place.room
      result[:policy_attributes] = place.policy
      result[:rule_attributes] = place.rule
      result[:ratings] = place.ratings
      facility = []
      PlaceFacility.where(place_id: place.id).each do |f|
        facility << Facility.find_by(id: f.facility_id).name
      end

      result[:place_facilities_attributes] = facility

      return render_success_response(:ok, PlaceResFormat, {data: result}, message: "Get place successfully") if place

      error!("Place not found", 404)
    end

    desc "get total number of place by city"

    params do
      requires :city, type: Symbol, values: [:hanoi, :hcm, :danang, :nhatrang, :dalat, :quangninh, :hoian, :vungtau]
    end

    get "/city/:city/count" do
      places = Place.where(city: params[:city])

      count = places.count if places

      return render_success_response(:ok, PlaceCountFormat, {data: count}, message: "Get place successfully") if places
    end

    desc "get place by city pagination"

    params do
      requires :city, type: Symbol, values: [:hanoi, :hcm, :danang, :nhatrang, :dalat, :quangninh, :hoian, :vungtau]
      requires :page, type: Integer
    end

    get "/city/:city/page/:page" do
      results = []
      page = params[:page] - 1

      places = Place.where(city: params[:city]).limit(20).offset(page * 20)

      places.each do |place|
        result = {}
        result[:name] = place.name
        result[:id] = place.id
        result[:details] = place.details
        result[:image] = place.image
        result[:host] = User.find_by id: place.user_id
        result[:address] = place.address
        result[:place_type] = place.place_type
        facility = []
        PlaceFacility.where(place_id: place.id).each do |f|
          facility << Facility.find_by(id: f.facility_id).name
        end
        result[:place_facilities_attributes] = facility
        result[:schedule_price_attributes] = place.schedule_price
        result[:room_attributes] = place.room
        result[:policy_attributes] = place.policy
        result[:rule_attributes] = place.rule
        result[:ratings] = place.ratings
        result[:overviews_attributes] = place.overviews

        results << result
      end

      return render_success_response(:ok, PlaceResFormat, {data: results}, message: "Get place successfully") if places

      error!(places.errors.full_messages[0], :bad_request)
    end

    desc "Admin accept or deny owner's request"

    params do
      requires :accepted, type: String
    end

    patch "/:place_id/check" do
      authenticated
      admin_authenticated

      place = Place.find_by id: params[:place_id]
      result = place.update accepted: params[:accepted]

      if result
        return render_success_response(:ok, PlaceResFormat, {data: place}, I18n.t("messages.success.place.requested"))
      end

      error!(place.errors.full_messages[0], :bad_request)
    end

    desc "Rate a place"

    params do
      requires :place_id
      optional :score, type: Integer, values: [1, 2, 3, 4, 5]
      optional :comment, type: String
    end

    post "/:place_id/rating/new" do
      authenticated

      data = valid_params params, Rating::RATING_PARAMS
      data[:place_id] = params[:place_id]
      data[:score] = params[:score]
      data[:comment] = params[:comment]

      rating = current_user.ratings.build data

      if rating.valid?
        rating.save

        data[:user_name] = current_user.name
        data[:user_avatar] = current_user.avatar
        data[:id] = rating[:id]

        return render_success_response(:ok, RatingResFormat, {data: data}, "success")
      end

      error!(rating.errors.full_messages[0], :bad_request)
    end

    get "/:place_id/ratings" do
      ratings = Place.find_by(id: params[:place_id]).ratings
      error!(rating.errors.full_messages[0], :bad_request) unless ratings

      results = []
      ratings.each do |r|
        result = {}
        result[:id] = r.id
        result[:place_id] = r.place_id
        result[:score] = r.score
        result[:comment] = r.comment
        result[:user_name] = User.find_by(id: r.user_id).name
        result[:user_avatar] = User.find_by(id: r.user_id).avatar

        results << result
      end
      return render_success_response(:ok, RatingResFormat, {data: results}, "success")
    end

    desc "Search a place by name or address"

    params do
      requires :page, type: Integer
      requires :search, type: String
    end

    get "/search/:search/:page" do
      results = []
      page = params[:page] - 1
      search = "%#{params[:search].downcase}%"

      places = Place.where("lower(name) like ? or lower(address) like ?", search, search)

      count = places.count if places

      places = places.limit(20).offset(page * 20)

      places.each do |place|
        result = {}
        result[:name] = place.name
        result[:id] = place.id
        result[:details] = place.details
        result[:image] = place.image
        result[:host] = User.find_by id: place.user_id
        result[:address] = place.address
        result[:place_type] = place.place_type
        facility = []
        PlaceFacility.where(place_id: place.id).each do |f|
          facility << Facility.find_by(id: f.facility_id).name
        end
        result[:place_facilities_attributes] = facility
        result[:schedule_price_attributes] = place.schedule_price
        result[:room_attributes] = place.room
        result[:policy_attributes] = place.policy
        result[:rule_attributes] = place.rule
        result[:ratings] = place.ratings
        result[:overviews_attributes] = place.overviews

        results << result
      end

      return render_success_response(:ok, PlaceSearchFormat, {data: results, count: count}, message: "Get place successfully") if places

      error!(places.errors.full_messages[0], :bad_request)
    end

    desc "Filter a place by price or facilities"

    params do
      requires :city, type: Symbol, values: [:hanoi, :hcm, :danang, :nhatrang, :dalat, :quangninh, :hoian, :vungtau]
      requires :page, type: Integer
      optional :min_price, type: Float
      optional :max_price, type: Float
      optional :num_of_bed, type: Integer
      optional :num_of_bedroom, type: Integer
      optional :num_of_bathroom, type: Integer
    end

    get "/filter/:city/:page" do
      results = []
      page = params[:page] - 1

      min_price = params[:min_price]
      max_price = params[:max_price]
      num_of_bed = params[:num_of_bed]
      num_of_bedroom = params[:num_of_bedroom]
      num_of_bathroom = params[:num_of_bathroom]

      places = Place.where(city: params[:city])
                    .eager_load(:schedule_price)
                    .where(schedule_prices: { normal_day_price: min_price..max_price })
                    .references(:schedule_prices)
                    .eager_load(:room)

      if num_of_bed
        places = places.eager_load(:room)
              .where(rooms: { num_of_bed: num_of_bed })
              .references(:rooms)
      end
      
      if num_of_bedroom
        places = places.eager_load(:room)
              .where(rooms: { num_of_bedroom: num_of_bedroom })
              .references(:rooms)
      end

      if num_of_bathroom
        places = places.eager_load(:room)
              .where(rooms: { num_of_bathroom: num_of_bathroom })
              .references(:rooms)
      end

      count = places.count if places

      places = places.limit(20).offset(page * 20)

      places.each do |place|
        result = {}
        result[:name] = place.name
        result[:id] = place.id
        result[:details] = place.details
        result[:image] = place.image
        result[:host] = User.find_by id: place.user_id
        result[:address] = place.address
        result[:place_type] = place.place_type
        facility = []
        PlaceFacility.where(place_id: place.id).each do |f|
          facility << Facility.find_by(id: f.facility_id).name
        end
        result[:place_facilities_attributes] = facility
        result[:schedule_price_attributes] = place.schedule_price
        result[:room_attributes] = place.room
        result[:policy_attributes] = place.policy
        result[:rule_attributes] = place.rule
        result[:ratings] = place.ratings
        result[:overviews_attributes] = place.overviews

        results << result
      end

      return render_success_response(:ok, PlaceSearchFormat, {data: results, count: count}, message: "Get place successfully") if places

      error!(places.errors.full_messages[0], :bad_request)
    end
  end
end
