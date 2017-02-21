class Activity < ApplicationRecord
    # Parent can be either an activity or an umbrella category
    # Children are activities or nil if leaf node.
    belongs_to :parent, :polymorphic => true
    has_many :children_activity, :as => :parent
    has_one :impact, :foreign_key => "activity_id"
end
