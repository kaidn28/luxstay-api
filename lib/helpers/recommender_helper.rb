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
        raise "wrong dimension" unless vector1.size == vector2.size
        dot_mul = vector1.dot(vector2)
        norm_mul = vector1.norm * vector2.norm
        if norm_mul != 0
            return dot_mul.to_f/norm_mul
        else 
            return 0
        end
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

    def createSimilarityVector(up_mat, current_user_idx)
        # puts current_user_idx
        # puts "shape: #{up_mat.row_count}, #{up_mat.column_count}"
        cUser_vector = up_mat.row(current_user_idx)
        # puts cUser_vector
        # puts cUser_vector
        sim_array = []
        up_mat.row_vectors.each do | row |
            sim_array << cosine(cUser_vector, row)
            puts cosine(cUser_vector, row)
        end
        return Vector.elements(sim_array)
    end 

    def collaborativeFiltering(city, num_rec)
        users = User.select('users.*').joins(:favorites).group("users.id").having('count(favorites.id)>1').to_a
        places = Place.where(city: city)
        #create user-place bookmark matrix
        up_mat = Matrix.zero(users.size, places.size)
        #map place index with in-matrix index
        p_idx_map = places.map.with_index{|place, idx|[place.id, idx]}.to_h
        #map user index with in-matrix index
        u_idx_map = users.map.with_index{|user, idx|[user.id, idx]}.to_h
        cUser_favors_id = []
        users.each.with_index do |user, u_idx|
            user.favorites.each do |favor|
                place = Place.find_by(id: favor.place_id)
                if place.city == city
                    p_idx = p_idx_map[favor.place_id]
                    up_mat[u_idx, p_idx] = 1
                    if user.id == current_user.id
                        cUser_favors_id << place.id
                    end
                end
            end
        end
        normalize_mat = Matrix.build(users.size, places.size){|r,c| up_mat.row(r).norm/places.size.to_f}
        up_mat = up_mat - normalize_mat
        puts "cUser_favors_id"
        puts cUser_favors_id
        sim_vector = createSimilarityVector(up_mat, u_idx_map[current_user.id])
        unmark_places = places.where.not(id: cUser_favors_id)
        if sim_vector.norm == 0
            rec_places = unmark_places.sample(num_rec).map{|place| formatPlace(place)}
        else 
            un_p_vectors = []
            places_list = []
            unmark_places.each do |un_p|    
                rated_sims = []
                un_p_idx = p_idx_map[un_p.id]
                un_p_array = up_mat.column(un_p_idx).to_a
                un_p_array.each.with_index do |s, i|
                    if s > 0 
                        rated_sims << [s, sim_vector[i], i]
                    end
                end
                rated_sims.sort_by!{|item| item[1]}.reverse!
                num_neighbor = [3, rated_sims.size].max
                nor = 0
                denor = 0
                rated_sims[..(num_neighbor-1)].each do |r|
                    nor += r[0]*r[1]
                    denor += r[1].abs
                end
                mean_rate = nor/(denor+0.00000001)
                # puts(mean_rate) if mean_rate > 0
                places_list << [un_p.id, mean_rate]
            end
            rec_places_id = places_list.sort_by!{|item| item[1]}.reverse![..(num_rec-1)]
            rec_places = rec_places_id.map{|id_c| formatPlace(Place.find_by(id: id_c[0]), confidence: id_c[1])}
        end
        
        
        return rec_places
    end
end