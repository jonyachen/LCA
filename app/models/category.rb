class Category < ApplicationRecord
    has_many :children_activity, :as => :parent
    has_many :descendent_activity, :through => :children_activity
end
