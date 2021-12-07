module RecommenderHelper
    def vectorizeData 
        places = Place.limit(10)
        puts 'abcxyz'
        puts places
        data = []
        
        places.each do |place|
            obj = {}
            obj[:normal_day_price] = place.schedule_price.normal_day_price
            obj[:weekend_price] = place.schedule_price.weekend_price
            obj[:cleaning_price] = place.schedule_price.cleaning_price
            obj[:square] = place.room.square
            obj[:num_of_bedroom] = place.room.num_of_bedroom
            obj[:num_of_bathroom] = place.room.num_of_bathroom
            obj[:num_of_bed] = place.room.num_of_bed
            obj[:currency_usd] = place.policy.currency == 'usd'? 1 : 0
            obj[:currency_vnd] = place.policy.currency == 'vnd'? 1 : 0
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
            vector_obj = obj.map{ |key, value| value}
            data.push(vector_obj)
        end
        return data
    end
    def showVectorizedData data
        attributes = [
            "normal day price", 
            "weekend price",
            "cleaning price",
            "square",
            "number of bedrooms",
            "number of bathrooms",
            "number of beds",
            "currency usd",
            "currency vnd",
            "maximum number of people",
            "overall rating score",
            "number of ratings"
        ]
        sData = data.map{ 
            |vector| 
            vector.map.with_index{
                |att, idx|
                [attributes[idx], att]
            }.to_h
        }
        present sData
    end
end