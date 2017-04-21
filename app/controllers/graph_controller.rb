class GraphController < ApplicationController
    def index
        #Graphing this data (params from create method)
        data_json = params[:data]
        gon.data = data_json
    end    
    
    def create
        require 'json'

        def create_obj_hash(type, activity, children)
            a_hash = activity
            if (type == "activity")
                a_id = activity["activity_id"]
                temp_id = a_id
                temp_a = Activity.find(temp_id)
                a = Activity.find(a_id)
                a_hash["name"] = a.name
                parent_type = a.parent_type
                while parent_type != "Category"
                    temp_a = Activity.find(temp_id)
                    temp_id = temp_a.parent_id
                    parent_type = temp_a.parent_type
                end
                puts a.name
                puts a_id
                puts "TEMP ACTIVITY"
               
               puts temp_id
               puts temp_a
               puts temp_a.name
               puts Category.find(temp_a.parent_id).name
                a_hash["category"] = Category.find(temp_a.parent_id).name
            else
                # For subassembly objects
                puts "its a category?"
                a_hash["activity_id"] = nil
                a_hash["name"] = activity["name"]
            end
        
            #value, uncertainty_lower, uncertainty_upper = Impact.get_value(type, a_hash)
            total_impact = Impact.calc_impact(type, a_hash)
            total_uncertainty_l, total_uncertainty_u = Impact.calc_uncertainties(type, a_hash)
            a_hash["value"] = total_impact
            a_hash["uncertain_lower"] = total_uncertainty_l
            a_hash["uncertain_upper"] = total_uncertainty_u
            
           
            unless children.nil?
                a_hash["children"] = children
            end
            puts "A HASH"
            puts a_hash
            return a_hash
        end
        
        
        
        
        data = []
        puts "MODEL"
        model = Assembly.find(session[:assembly_id]).components_json
        model = JSON.parse(model.gsub(/"(\d+)"/, '\1'))
        
        puts model
        
        model.each_with_index { |category, index|
            if category["children"].nil?
                activities = category
            else
                activities = category["children"]
            end
            category_children = []
            activities.each { |top_lvl_activity|
                #puts top_lvl_activity
                if top_lvl_activity.key?("children")
                    activity_children = []
                    top_lvl_activity["children"].each { |inner_lvl_activity|
                        inner_hash = create_obj_hash("activity", inner_lvl_activity, nil)
                        activity_children << inner_hash
                        puts "INNER HASH"
                        puts inner_hash
                    }
                end
                top_level_hash = create_obj_hash("activity", top_lvl_activity, activity_children)
                puts "TOP LEVEL HASH"
                puts top_level_hash
                category_children << top_level_hash
            }
            category_hash = create_obj_hash("category", category, category_children)
            data << category_hash
        }
        
        data_json = data.to_json
        puts "DATA JSON"
        puts data_json
        redirect_to :action => "index", :data => data_json
    end
end
