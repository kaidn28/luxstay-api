class RecommenderApi < ApiV1
    namespace :recommender do
        get '/places' do
            places = Place.limit(3)
            data = []
            
            places.each do |place|
                obj = {}
                obj[:normal_day_price] = place.schedule_price.normal_day_price
                obj[:weekend_price] = place.schedule_price.weekend_price
                obj[:cleaning_price] = place.schedule_price.cleaning_price
                obj[:room_attributes] = place.room
                obj[:square] = place.room.square
                obj[:num_of_bedroom] = place.room.num_of_bedroom
                obj[:num_of_bathroom] = place.room.num_of_bathroom
                obj[:num_of_bed] = place.room.num_of_bed
                obj[:currency] = place.policy.currency
                obj[:max_num_of_people] = place.policy.max_num_of_people
                if place.ratings.empty?
                    obj[:overall_rating_score] = 4.0
                    obj[:num_ratings] = 1
                else 
                    sum = 0
                    place.ratings.each do |r|
                        sum += r.score.to_f
                    end
                    obj[:overall_rating_score] = sum / place.ratings.length
                    obj[:num_ratings] = place.ratings.length
                end
                obj[:ratings] = place.ratings
                data.push(obj)
            end
            present data
        end
    end
end 
