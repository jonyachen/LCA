class Impact < ApplicationRecord
    belongs_to :activity
    
    # Calculates total impact factoring in units and quantity inputs
    def self.calc_impact(type, activity)
        id = activity["activity_id"]
        quantity = activity["quantity"]
        units = activity["units"]
        
        if (type == "category")
            puts "category"
            total_impact = 0 # temporary
        else
            unit_conv_factor = Unit.unit_conversion(id, units)
            impact_per_unit = Impact.get_children_impact(id)
            impact_per_unit = impact_per_unit[0] / impact_per_unit[1]
            total_impact = quantity * impact_per_unit * unit_conv_factor
        end
        return total_impact
    end
    
    # Calculates total uncertainties factoring in units and quantity inputs
    def self.calc_uncertainties(type, activity)
        id = activity["activity_id"]
        quantity = activity["quantity"]
        units = activity["units"]
        
        if (type == "category")
            puts "category"
            total_uncertainty_l = 0 #temp
            total_uncertainty_u = 0 #temp
        else
            unit_conv_factor = Unit.unit_conversion(id, units)
            uncertainties = Impact.get_children_uncertainties(id)
            uncertainty_lower = uncertainties[0].max
            uncertainty_upper = uncertainties[1].max
            total_uncertainty_l = quantity * uncertainty_lower * unit_conv_factor
            total_uncertainty_u = quantity * uncertainty_upper * unit_conv_factor
        end
        return total_uncertainty_l, total_uncertainty_u
    end
    
    
    # Calculates sum of children per unit impacts and number of children for a given umbrella activity recursively
    # Returns an array of [children impact sum, children len]
    def self.get_children_impact(id)
        activity = Impact.where(activity_id: id)
        if activity.present?
            return [activity.first.impact_per_unit, 1]
        else
            node_sum = 0
            node_out_len = 0
            children_activities = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
            children_activities.each { |child|
                child_impact = self.get_children_impact(child.id)
                node_sum += child_impact[0]
                node_out_len += child_impact[1]
            }
            return [node_sum, node_out_len]
        end
    end
    
    # Returns an array: [[children's lower uncertainties], [children's upper uncertainties]] per unit
    def self.get_children_uncertainties(id)
        activity = Impact.where(activity_id: id)
        if activity.present?
            return [[activity.first.uncertainty_lower], [activity.first.uncertainty_upper]]
        else
            uncertainty_lower = []
            uncertainty_upper = []
            children_activities = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id)
            children_activities.each { |child|
                child_uncertainties = self.get_children_uncertainties(child.id)
                uncertainty_lower += child_uncertainties[0]
                uncertainty_upper += child_uncertainties[1]
            }
            return [uncertainty_lower, uncertainty_upper]
        end
    end
end
