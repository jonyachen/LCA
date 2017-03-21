class Activity < ApplicationRecord
    # Parent can be either an activity or an umbrella category
    # Children are activities or nil if leaf node.
    belongs_to :parent, :polymorphic => true
    has_many :children_activity, :as => :parent
    has_one :impact, :foreign_key => "activity_id"
    
    def self.categories
        return Activity.all.select(:parent_type).map(&:parent_type).uniq
    end
    
    def self.get_category(id)
        while Activity.find(id).parent_type != "Category" do
            # Continue searching parent activities iteratively until the parent is a category
            id = Activity.find(id).parent_id
        end
        # Then return the id of the category
        return Activity.find(id).parent_id
    end

    
end
