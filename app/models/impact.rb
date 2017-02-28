
class Impact < ApplicationRecord
    belongs_to :activity
    
    def self.get_value(type, id, quantity, children)
        if (type == "category")
            value = 0
            children.each { |child|
                value += child["value"]
            }
        else
            # Still need to do unit conversions
            if !(Impact.where(activity_id: id).present?)
                # If not a leaf node, estimated value is the avg of children values
                value = quantity * Impact.calc_avg_values(id)
            else
                value = quantity * Impact.where(activity_id: id).first.impact_per_unit
            end
        end
        return value
    end
    
    def self.get_uncertainty(type, id, value, children)
        if (type == "category")
            children.each_with_index { |child, index|
                puts "Category " + (index+1).to_s
                if (index == 0)
                    @cat_error_min = child["value"] - child["uncertain_lower"]
                    @cat_error_max = child["value"] + child["uncertain_upper"]
                end
                puts child["value"]
                puts child["uncertain_lower"]
                puts child["uncertain_upper"]
                puts
                curr_lower = child["value"] - child["uncertain_lower"]
                curr_upper = child["value"] + child["uncertain_upper"]
                if (curr_lower < @cat_error_min)
                    @cat_error_min = curr_lower
                end
                if (curr_upper > @cat_error_max)
                    @cat_error_max = curr_upper
                end
            }
            @uncertainty_lower = value - @cat_error_min
            @uncertainty_upper = @cat_error_max - value
        else
            if !(Impact.where(activity_id: id).present?)
                # If not a leaf node, uncertainty is defined by min of children's lower bound and max of their upper bound
                Impact.set_min_max(id)
                avg = Impact.calc_avg_values(id)
                @uncertainty_lower = Impact.calc_uncertain_lower(avg)
                @uncertainty_upper = Impact.calc_uncertain_upper(avg)
            else
                @uncertainty_lower = Impact.get_uncertain_lower(id)
                @uncertainty_upper = Impact.get_uncertain_upper(id)
            end
        end    
        return @uncertainty_lower, @uncertainty_upper
    end
    
    
            
    # If uncertainty values exist, return by querying the active record.
    def self.get_uncertain_lower(id)
        return Impact.where(activity_id: id).first.uncertainty_lower
    end
    
    def self.get_uncertain_upper(id)
        return Impact.where(activity_id: id).first.uncertainty_upper
    end
    
    # If there is no impact in the database, calculate value and uncertainty based on children nodes
    def self.set_min_max(id)
        # Sets the minimum/maximum value based on children uncertainty used to calculate lower/upper error bound
        children_activities = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
        Impact.where(activity_id: children_activities).each_with_index { |impact, index|
            if (index == 0)
                @min = impact.impact_per_unit - impact.uncertainty_lower
                @max = impact.impact_per_unit + impact.uncertainty_upper
            end
            diff = impact.impact_per_unit - impact.uncertainty_lower
            sum = impact.impact_per_unit + impact.uncertainty_upper
            if (diff < @min)
                @min = diff
            end
            if (sum > @max)
                @max = sum
            end
        }
    end
    
    def self.calc_avg_values(id)
        # Returns the average value of children values
        children_activities = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
        sum = 0
        Impact.where(activity_id: children_activities).each { |impact|
            sum += impact.impact_per_unit
        }
        return sum/children_activities.length
    end
    
    def self.calc_uncertain_lower(avg)
        # Returns the lower error bound
        return avg - @min
    end
    
    def self.calc_uncertain_upper(avg)
        # Returns the upper error bound
        return @max - avg
    end
    
end
