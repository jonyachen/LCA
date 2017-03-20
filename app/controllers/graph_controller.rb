class GraphController < ApplicationController
    def index
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
        
        model = File.read("app/assets/json/model.json")
        data = File.read("app/assets/json/data.json")
        
        data2 = []
        
        model_hash = JSON.parse(model)
        puts model_hash
        
        model_hash.each_with_index { |category, index|
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
            data2 << category_hash
        }
        data2_json = data2.to_json
        #puts data2_json
        
        gon.data = data2_json
        #gon.data = data
        puts "Build"
        puts params[:build]
        
        puts "Test"
        puts params
        
        puts "test2"
        puts :params
    end    
    
    def create
        require 'json'
        puts params[:build]
        #redirect_to action: "index"
    end
    
    def new
    end
    
    def edit
    end
    
    def show
    end
    
    def update
    end
    
    def destroy
    end
end
