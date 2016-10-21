class Part < ApplicationRecord
    
    validates_uniqueness_of :title, :on => :create
    
    def self.find_part(title)
        # This is very unsafe and need to add salt to it. 
        return Part.where('title LIKE :query', query: "%#{title}%").first
    end
end
