
class User < ApplicationRecord
    has_many :projects
    has_many :assemblys

    validates_uniqueness_of :username, :on => :create
    validates_uniqueness_of :email, :on => :create

    validates_presence_of :username
    validates_presence_of :email
    validates_presence_of :password
    validates_presence_of :name

    class_attribute :salt

    def self.salt
       '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
    end

    def self.authenticate(login, pass)
       User.where(["username = ? OR email = ? AND password = ?", login, login, password_hash(pass)]).first
       # find(:first,
       #    :conditions => ["username = ? OR email = ? AND password = ?", login, login, password_hash(pass)])
    end

    def self.authenticate?(login, pass)
       user = self.authenticate(login, pass)
       return false if user.nil?
       return true if user.login == login

       false
    end

    def password=(newpass)
       @password = newpass
    end

    def password(cleartext = nil)
       if cleartext
          @password.to_s
       else
          @password || read_attribute("password")
       end
    end

    protected

    def self.password_hash(pass)
       Digest::SHA1.hexdigest("#{salt}--#{pass}--")
    end

    def password_hash(pass)
       self.class.password_hash(pass)
    end

    before_create :crypt_password

    def crypt_password
       write_attribute "password", password_hash(password(true))
       @password = nil
    end

    before_update :crypt_unless_empty

    def crypt_unless_empty
       if password(true).empty?
             user = self.class.find(self.id)
             write_attribute "password", user.password
       else
          crypt_password
       end
    end

end
