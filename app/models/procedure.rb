class Procedure < ApplicationRecord
    validates_uniqueness_of :title, :on => :create
    def self.find_procedure(title)
        # This is very unsafe and need to add salt to it. 
        return Procedure.where('title LIKE :query', query: "%#{title}%").first
    end
end
