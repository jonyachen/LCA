class Impact < ApplicationRecord
    belongs_to :activity
    
    def self.get_value(type, activity)
        id = activity["activity_id"]
        quantity = activity["quantity"]
        units = activity["units"]
        
        children = activity["children"]
        
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
                #puts "CHILD"
                #puts child
                @value += child["value"]
                @uncertainty_lower += child["quantity"] * child["uncertain_lower"]
                @uncertainty_upper += child["quantity"] * child["uncertain_upper"]
            }
        else
            # Conversion factor converts units to the units that are stored in the database for that activity
            unit_conv_factor = Unit.unit_conversion(id, units)
            if !(Impact.where(activity_id: id).present?)
                # If not a leaf node, estimated value is the avg of children values and
                # uncertainty is defined by min of children's lower bound and max of their upper bound
                
                @value = quantity * Impact.calc_avg_values(id) * unit_conv_factor
                absolute_min_error, absolute_max_error = Impact.get_min_max(id) * unit_conv_factor
                #puts "ABS MIN"
                #puts absolute_min_error
                #puts "ABS MAX"
                #puts absolute_max_error
                @uncertainty_lower = @value - quantity * absolute_min_error
                @uncertainty_upper = quantity * absolute_max_error - @value
            else
                # If a leaf node, simply return the values stored in DB
                @value = quantity * Impact.where(activity_id: id).first.impact_per_unit * unit_conv_factor
                @uncertainty_lower = quantity * Impact.where(activity_id: id).first.uncertainty_lower * unit_conv_factor
                @uncertainty_upper = quantity * Impact.where(activity_id: id).first.uncertainty_upper * unit_conv_factor
            end
        end
        return @value, @uncertainty_lower, @uncertainty_upper
    end

    
    # If there is no impact in the database, find minimum and maximum of children uncertainty
    def self.get_min_max(id)
        def self.recursive_min_max(id)
            children = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
            children.each_with_index { |child, index|
                impact = Impact.where(activity_id: child.id)
                
                if !(impact.present?)
                    min, max = self.recursive_min_max(child.id)
                    if (index == 0)
                        @min = min
                        @max = max
                    end
                else
                    impact = impact.first
                    if (index == 0)
                        @min = impact.impact_per_unit - impact.uncertainty_lower
                        @max = impact.impact_per_unit + impact.uncertainty_upper
                    end
                    min = impact.impact_per_unit - impact.uncertainty_lower
                    max = impact.impact_per_unit + impact.uncertainty_upper
                end
                #puts "MIN"
                #puts min
                if (min < @min)
                    @min = min
                end
                if (max > @max)
                    @max = max
                end
            }
            return @min, @max
        end
        
        @min = nil
        @max = nil
        self.recursive_min_max(id)
        
        # Returns the minimum/maximum per unit value based on children uncertainty used to calculate lower/upper error bound
        
     
     #   Impact.where(activity_id: children_activities).each_with_index { |impact, index|
     #       if (index == 0)
     #           @min = impact.impact_per_unit - impact.uncertainty_lower
     #           @max = impact.impact_per_unit + impact.uncertainty_upper
     #       end
     #       diff = impact.impact_per_unit - impact.uncertainty_lower
     #       sum = impact.impact_per_unit + impact.uncertainty_upper
     #       if (diff < @min)
     #           @min = diff
     #       end
     #       if (sum > @max)
     #           @max = sum
     #       end
     #   }
        return @min, @max
    end
    
    def self.calc_avg_values(id)
        def self.recursive_sum(id, sum)
            children = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
            value = 0
            children.each { |child|
                if !(Impact.where(activity_id: child.id).present?)
                    puts child.id
                    #value = self.recursive_sum(child.id, sum)
                    #sum += value
                    #puts value
                    return sum + self.recursive_sum(child.id, sum)
                else
                    puts child.id
                    value += Impact.where(activity_id: child.id).first.impact_per_unit
                    #sum += value
                    #puts value
                    #return value
                end
                
            }
            puts value
            return value
        end
        
        # Returns the average value of children values
        sum = 0
        @sum = self.recursive_sum(id, sum)
        children = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
        
        #Impact.where(activity_id: children_activities).each { |impact|
        #    puts "adding sum"
        #    puts sum
        #    sum += impact.impact_per_unit
        #}
        #return @sum / children.length
        return @sum
    end
    
end
