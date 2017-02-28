class Assembly < ApplicationRecord
	serialize :components
	belongs_to :user
	
	#def self.deblob
	def deblob
		return self.components.fixed
	end
end
