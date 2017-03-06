class Impact < ApplicationRecord
    belongs_to :activity
    
    def self.get_value(type, id, quantity, children)
        # Overall value of categories is the sum of all children activities
        if (type == "category")
            @uncertainty_lower = @uncertainty_upper = @value = 0
            children.each { |child|
                unless child["children"].nil?
                    child["children"].each { |innerChild|
                        @value += innerChild["value"]
                        @uncertainty_lower += innerChild["quantity"] * innerChild["uncertain_lower"]
                        @uncertainty_upper += innerChild["quantity"] * innerChild["uncertain_upper"]
                    }
                end
                @value += child["value"]
                @uncertainty_lower += child["quantity"] * child["uncertain_lower"]
                @uncertainty_upper += child["quantity"] * child["uncertain_upper"]
            }
        else
            # Still need to do unit conversions
            if !(Impact.where(activity_id: id).present?)
                # If not a leaf node, estimated value is the avg of children values and
                # uncertainty is defined by min of children's lower bound and max of their upper bound
                @value = quantity * Impact.calc_avg_values(id)
                absolute_min_error, absolute_max_error = Impact.get_min_max(id)
                @uncertainty_lower = @value - quantity * absolute_min_error
                @uncertainty_upper = quantity * absolute_max_error - @value
            else
                # If a leaf node, simply return the values stored in DB
                @value = quantity * Impact.where(activity_id: id).first.impact_per_unit
                @uncertainty_lower = Impact.where(activity_id: id).first.uncertainty_lower
                @uncertainty_upper = Impact.where(activity_id: id).first.uncertainty_upper
            end
        end
        return @value, @uncertainty_lower, @uncertainty_upper
    end

    
    # If there is no impact in the database, find minimum and maximum of children uncertainty
    def self.get_min_max(id)
        @min = nil
        @max = nil
        # Returns the minimum/maximum per unit value based on children uncertainty used to calculate lower/upper error bound
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
        return @min, @max
    end
    
    def self.calc_avg_values(id)
        # Returns the average value of children values
        children_activities = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
        sum = 0
        Impact.where(activity_id: children_activities).each { |impact|
            sum += impact.impact_per_unit
        }
        return sum / children_activities.length
    end
    
end
