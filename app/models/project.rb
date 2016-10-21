class Project < ApplicationRecord
    has_many :models
    
    validates_uniqueness_of :title, :on => :create
    
    def self.find_project(title)
        # This is very unsafe and need to add salt to it. 
        return Project.where('title LIKE :query', query: "%#{title}%").first
    end
    
end
