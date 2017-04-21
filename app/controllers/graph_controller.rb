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
                a_hash["category"] = Category.find(temp_a.parent_id).name
            else
                a_hash["activity_id"] = nil
                a_hash["name"] = activity["name"]
            end
           
            unless children.nil?
                a_hash["children"] = children
                a_hash["value"] = 0
                a_hash["uncertain_lower"] = 0
                a_hash["uncertain_upper"] = 0
                children.each { |child|
                    a_hash["value"] += child["value"]
                    a_hash["uncertain_lower"] += child["uncertain_lower"]
                    a_hash["uncertain_upper"] = child["uncertain_upper"]
                }
            else
                total_impact = Impact.calc_impact(type, a_hash)
                total_uncertainty_l, total_uncertainty_u = Impact.calc_uncertainties(type, a_hash)
                a_hash["value"] = total_impact
                a_hash["uncertain_lower"] = total_uncertainty_l
                a_hash["uncertain_upper"] = total_uncertainty_u
            end
            return a_hash
        end
        
        data = []
        model = Assembly.find(session[:assembly_id]).components_json
        model = JSON.parse(model.gsub(/"(\d+)"/, '\1'))
        model.each_with_index { |category, index|
            if category["children"].nil?
                activities = category
            else
                activities = category["children"]
            end
            category_children = []
            activities.each { |top_lvl_activity|
                if top_lvl_activity.key?("children")
                    activity_children = []
                    top_lvl_activity["children"].each { |inner_lvl_activity|
                        inner_hash = create_obj_hash("activity", inner_lvl_activity, nil)
                        activity_children << inner_hash
                    }
                    # Include top level activity in children drilldown for graphing
                    top_no_children = Hash.new()
                    top_no_children["activity_id"] = top_lvl_activity["activity_id"]
                    top_no_children["quantity"] = top_lvl_activity["quantity"]
                    top_no_children["units"] = top_lvl_activity["units"]
                    activity_children << create_obj_hash("activity", top_no_children, nil)
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
