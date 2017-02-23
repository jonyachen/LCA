class GraphsController < ApplicationController
    @@data = File.read("app/assets/json/data.json")
    
    def lca

        activity_ids = [5, 6, 7]
        quantity = [1, 3, 2]
        units = ["kg", "kg", "kg"]
        
        activity_ids.each { |id|
            activity = Impact.where("activity_id = ?", id)
            puts activity.name
        }
        #Impact.where("activity_id = ?", activity_ids).each do |impact|
        #    activity_name = Activity.find(impact.activity_id)
        #    puts activity_name
        #    puts impact.impact_per_unit
        #    puts impact.uncertainty_lower
        #    puts impact.uncertainty_upper
        #    puts "\n"
        #end
        
        gon.data = @@data
    end
end
