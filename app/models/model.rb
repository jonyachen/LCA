class Model < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    has_many :subassemblies
    has_many :materials
    
    validates_uniqueness_of :title, :on => :create
    
    def self.find_model(title)
        # This is very unsafe and need to add salt to it. 
        return Model.where('title LIKE :query', query: "%#{title}%").first
    end
end
