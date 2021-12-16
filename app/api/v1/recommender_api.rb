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
            results = contentBasedRecommender(params[:place_id], params[:num_rec])
            return render_success_response(:ok, RecResFormat, {data: results}, I18n.t("Request successful")) if results

            error!(I18n.t("Request failed"), :bad_request)
        end
    end
end 
