class Unit < ApplicationRecord
    def self.unit_conversion(id, units)
        # If the unit doesn't already match the activity's stored units, apply conversion
        activity_units = Activity.find(id).units
        
        # For umbrella activities that don't have units, sample a default unit from its children
        if !activity_units.present?
            sample = Activity.where("parent_type = ? AND parent_id = ?", "Activity", id).first
            while !sample.units.present? do
                temp_id = sample.id
                sample = Activity.where("parent_type = ? AND parent_id = ?", "Activity", temp_id).first
            end
            activity_units = sample.units
        end
        
        if (units != activity_units)
            return Unit.conversion_factor_SI(units) * Unit.conversion_factor_from_SI(activity_units)
        else
            return 1.0
        end
    end
    
    def self.conversion_factor_SI(units)
        return Unit.where("unit = ?", units).first.conversion_to_si
    end
    
    def self.conversion_factor_from_SI(units)
        return 1.0/Unit.where("unit = ?", units).first.conversion_to_si
    end
end
