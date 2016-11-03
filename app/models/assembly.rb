class Assembly < ApplicationRecord
	serialize :components
	belongs_to :user
end
