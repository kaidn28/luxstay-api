require 'matrix'
module RecommenderHelper

    def vectorizePlaces places 
        # puts 'abcxyz'
        # puts places
        data = []
        
        places.each do |place|
            vector = vectorizePlace(place)
            data.push(vector)
        end
        return data
    end

    def vectorizePlace place
        obj = {}
        obj[:normal_day_price] = place.schedule_price.normal_day_price
        obj[:weekend_price] = place.schedule_price.weekend_price
        obj[:cleaning_price] = place.schedule_price.cleaning_price
        obj[:square] = place.room.square.to_f
        obj[:num_of_bedroom] = place.room.num_of_bedroom.to_f
        obj[:num_of_bathroom] = place.room.num_of_bathroom.to_f
        obj[:num_of_bed] = place.room.num_of_bed.to_f
        obj[:currency_usd] = place.policy.currency == 'usd'? 1.0 : 0.0
        obj[:currency_vnd] = place.policy.currency == 'vnd'? 1.0 : 0.0
        obj[:max_num_of_people] = place.policy.max_num_of_people.to_f
        if place.ratings.empty?
            obj[:overall_rating_score] = 4.0
            obj[:num_ratings] = 1.0
        else 
            sum = 0.0
            place.ratings.each do |r|
                sum += r.score.to_f
            end
            obj[:overall_rating_score] = sum / place.ratings.length
            obj[:num_ratings] = place.ratings.length.to_f    
        end
        vector_obj = obj.map{ |key, value| value}
        vector = Vector.elements(vector_obj)
        return vector
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
        # require 'json'
        # File.open("data.json","w") do |f|
        #     f.write(sData.to_json)
        # end
        return sData
    end

    def meanVector data
        mean = data.inject{|vector, el|vector +el}/data.size
        return mean
    end

    def cosine (vector1, vector2)
        dot_mul = vector1.dot(vector2)
        norm_mul = vector1.norm * vector2.norm
        return dot_mul.to_f/norm_mul
    end
    def getMeanVAWLow favors
        vectors = vectorizePlaces(favors)
        meanVAW = []
        vectors.each.with_index do |f1, i1|
            vectors.each.with_index do |f2, i2|
                if i1 < i2
                    mean = meanVector([f1, f2])
                    score = cosine(f1, f2)
                    meanVAW << [mean, score]
                end
                meanVAW.sort_by!{|vaw| vaw[1]}.reverse!
            end
        end
        return meanVAW[..2]
    end

    def getMeanVAWHigh array
        return getMeanVAWLow(array)
    end
end