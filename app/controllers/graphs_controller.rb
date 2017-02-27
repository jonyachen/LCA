class GraphsController < ApplicationController
    def index
        @@data = File.read("app/assets/json/data.json")
    end    
    def fetch_data
        if session[:user_id] == nil
            puts "USER is NIL"
            # For Testing Purposes
            redirect_to welcome_path
            # @user = User.create
            # session[:user_id] = @user.id
        else
            @user = User.find(session[:user_id])
        end
        
        @activity_ids = [5, 6, 7]
        @quantity = [1, 3, 2]
        @units = ["kg", "kg", "kg"]
        
        @activity_ids.each { |id|
            @activity = Activity.find(id)
            puts @activity.name
            #@activity = Impact.where("activity_id = ?", id)
            #puts @activity
            #puts @activity.impact_per_unit
        }
        
        @activities = Activity.find(@activity_ids)
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
    
    def create
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
