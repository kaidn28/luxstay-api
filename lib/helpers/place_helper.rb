module PlaceHelper
    def formatPlace(place, confidence: 0.5)
        result = {}
        result[:name] = place.name
        result[:id] = place.id
        result[:confidence] = confidence
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
        return result
    end
    
end
  