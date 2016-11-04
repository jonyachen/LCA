class Material < ApplicationRecord
    
    has_many :procedures
    validates_uniqueness_of :title, :on => :create
    
    def self.find_material(title)
        # This is very unsafe and need to add salt to it. 
        return Material.where('title LIKE :query', query: "%#{title}%").first
    end
    
    def self.categories
        return Material.all.select(:category).map(&:category).uniq.sort
    end
end
