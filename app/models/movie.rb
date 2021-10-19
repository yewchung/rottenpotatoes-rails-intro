class Movie < ActiveRecord::Base
  
   def self.all_ratings
     ratings = []
     Movie.select(:rating).distinct.each do |r|
       ratings.push(r.rating)
     end
     return ratings
   end
  
   def self.with_ratings(ratings_list)
     if (ratings_list.nil?)
       return Movie.all()
     else
       return Movie.where(rating: ratings_list)
     end
   end
     
end
