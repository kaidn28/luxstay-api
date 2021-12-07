class BookmarkApi < ApiV1
  namespace :bookmark do
    before do
      authenticated
    end

    desc "Bookmark place"

    params do
      requires :place_id, type: String, message: I18n.t("messages.errors.required")
    end

    post "/new" do
      data = valid_params params, Favorite::BOOKMARK_PARAMS

      data[:place_id] = params[:place_id]

      exist = current_user.favorites.find_by(place_id: params[:place_id]).present?

      error!("This place has been bookmarked", :bad_request) if exist

      bookmark = current_user.favorites.build data

      if bookmark.valid?
        bookmark.save

        return render_success_response(:ok, BookmarkResFormat, {data: bookmark}, "Bookmark success")
      end

      error!(bookmark.errors.full_messages[0], :bad_request)
    end

    desc "Get all bookmarked places by User"

    get do
      results = []

      bookmarks = Favorite.where user_id: current_user.id

      bookmarks.each do |b|
        result = {}
        place = Place.find_by id: b.place_id
        result[:place_id] = place.id
        result[:place_name] = place.name
        result[:place_image] = place.image
        result[:place_price] = place.schedule_price.normal_day_price
        result[:place_address] = place.address
        results << result
      end
      return present({data: results}, nil, success: true, message: "success") if results
    end

    desc "Check place bookmarked"

    params do
      requires :place_id, type: Integer
    end

    post "/check" do
      bookmark = Favorite.where place_id: params[:place_id], user_id: current_user.id

      return present({data: true}, nil, success: true, message: "bookmarked") if bookmark.length > 0

      return present({data: false}, nil, success: true, message: "not bookmarked")
      # return json: {data: false, message: "has not bookmarked yet"}
    end

    desc "remove bookmark"

    delete "/remove" do
      bookmark = current_user.favorites.find_by place_id: params[:place_id]

      if bookmark
        bookmark.destroy

        return render_success_response(:ok, BookmarkResFormat, {data: bookmark}, "Bookmark has removed")
      end

      error!("Bookmark not found !", :bad_request)
    end
  end
end
