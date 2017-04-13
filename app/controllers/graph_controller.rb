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
                a = Activity.find(a_id)
                a_hash["name"] = a.name
            else
                # For category objects
                a_hash["activity_id"] = nil
                a_hash["name"] = activity["name"]
            end
        
            value, uncertainty_lower, uncertainty_upper = Impact.get_value(type, a_hash)
            a_hash["value"] = value
            a_hash["uncertain_lower"] = uncertainty_lower
            a_hash["uncertain_upper"] = uncertainty_upper
           
            unless children.nil?
                a_hash["children"] = children
            end
            return a_hash
        end
        
        # Old read-in data from json file
        #model_json = File.read("app/assets/json/model.json")
        #model = JSON.parse(model_json)
        
        data = []
        
        # New data from model_controller
        #model = JSON.parse(params[:build])
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
                    }
                end
                top_level_hash = create_obj_hash("activity", top_lvl_activity, activity_children)
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
