class User < ApplicationRecord
    has_many :projects
    
    validates_uniqueness_of :username, :on => :create
    validates_uniqueness_of :email, :on => :create
    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :password
    
    def self.authenticate(login, pass)
        # This is very unsafe and need to add salt to it. 
        return User.where('username LIKE :query OR email LIKE :query', query: "%#{login}%").first
    end
    
end
