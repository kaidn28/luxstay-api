class RecommenderApi < ApiV1
    namespace :recommender do
        get '/places' do
            data = vectorizeData
            showVectorizedData data
        end
    end
end 
