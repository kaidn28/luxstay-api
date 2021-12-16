class RecommenderApi < ApiV1
    namespace :recommender do
        before do
            authenticated
        end
        desc "recommend based on personal interest"
        params do 
            requires :city, type: String
            optional :num_rec, type: Integer, default: 10
        end
        get '/city/:city' do
            favors = current_user.favorites
            if favors.empty?
                fPlaces = Place.where(city: params[:city]).sample(params[:num_rec])
                results = fPlaces.map{|place| formatPlace(place)}
            else
                results = collaborativeFiltering(params[:city], params[:num_rec])
            end
            #present topNScores
            return render_success_response(:ok, RecResFormat, {data: results}, I18n.t("Request successful")) if results

            error!(I18n.t("Request failed"), :bad_request)
            
        end

        desc "recommend based on specific room"
        params do 
            requires :place_id, type: Integer
            optional :num_rec, type: Integer, default: 10
        end
        get "/:place_id" do
            favors = current_user.favorites
            fPlaces_id = []
            favors.each do |f|
                place = Place.find_by(id: f.place_id)
                if place.city == params[:city]
                    fPlaces_id << place.id
                end
            end
            target_place = Place.find_by id: params[:place_id]
            target_vector = vectorizePlace(target_place)
            places = Place.where(city: target_place.city).sample(100)  
            scores = []          
            places.each do |place|
                in_favor = false
                fPlaces_id.each do |p|
                    if place.id == p 
                        in_favor = true
                    end
                end 
                if place.id == target_place.id
                    in_favor = true
                end
                if !in_favor
                    vector = vectorizePlace(place)
                    score = cosine(target_vector, vector)
                    scores << [score, place.id]
                end
            end
            scores.sort_by!{|s|s[0]}.reverse!
            topNScores =  scores[..(params[:num_rec]-1)]
            results = []
            topNScores.each do |t|
                place = Place.find_by(id: t[1])
                result = formatPlace(place, confidence: t[0])
                results << result
            end
            return render_success_response(:ok, RecResFormat, {data: results}, I18n.t("Request successful")) if results

            error!(I18n.t("Request failed"), :bad_request)
        end
    end
end 
