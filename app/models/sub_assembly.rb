class SubAssembly < ApplicationRecord
    has_many :materials
    has_many :procedures
    
    validates_uniqueness_of :title, :on => :create
    
    def self.find_sub_assembly(title)
        # This is very unsafe and need to add salt to it. 
        return SubAssembly.where('title LIKE :query', query: "%#{title}%").first
    end
end
