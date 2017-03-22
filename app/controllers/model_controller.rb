class ModelController < ApplicationController
  def index
   #  before_action :authenticate_user!
    #session.clear()
    if session[:user_id] == nil
      puts "USER is NIL"
      # For Testing Purposes
      redirect_to welcome_path
      # @user = User.create
      # session[:user_id] = @user.id
    else
      @user = User.find(session[:user_id])
    end

    if session[:assembly_id] == nil or params[:new] == "true"
      puts "no assembly id"
      params[:new] = nil
      session[:assembly_id] = nil
      @curr_assembly = nil
      @curr_name = nil
      @model = nil
    else
      @curr_assembly = Assembly.find(session[:assembly_id]).components
      @curr_name = Assembly.find(session[:assembly_id]).name
      @model = Assembly.find(session[:assembly_id]).components_json
    end

    if params[:id] != nil
      if @user.assemblys.find_by_id(params[:id]) == nil
        params[:id] = nil
        redirect_to root_path
      else
        session[:assembly_id] = params[:id]
        @curr_assembly = @user.assemblys.find_by_id(params[:id]).components
        @curr_name = Assembly.find_by_id(params[:id]).name
      end
    end

  	@material_data = Hash[Material.all.collect {|material| [material.title, material.id]}]
  	@material_names = Hash[Material.all.collect {|material| [material.id, material.title]}]

  	@material_options = Material.categories.collect do |category|
  		[category, Material.where(category: category).collect {|material| [material.title, material.id]}]
  	end

  	@procedures = Hash[Procedure.categories.collect do |category|
  		[category, Material.all.collect do |material|
  			[material.title, Procedure.where(material: material.title, category: category).collect {|procedure| [procedure.title, procedure.id]}]
  		end
	  	]
  	end
  	]
  	
  	###
  	#New queries below
  	###
  	
  	@activities = Activity.categories.collect do |parent_type|
  		  [parent_type, Activity.where(parent_type: "Category").collect {|material| [material.name, material.id]}]
  	end
  	
  	@materials = Activity.where(parent_type: "Category", parent_id: "1")
  	@processes = Activity.where(parent_type: "Category", parent_id: "2")
  	@transport = Activity.where(parent_type: "Category", parent_id: "3")
  	@use = Activity.where(parent_type: "Category", parent_id: "4")
  	@endoflife = Activity.where(parent_type: "Category", parent_id: "5")
  	
  end
  

  def create
    require 'json'
    hash = params[:build]
    
    assembly = {"name" => params[:assembly_name], "children" => []}

    hash.each { |index, activity|
      activity_hash = Hash.new
      activity_hash["activity_id"] = activity["id"]
      activity_hash["quantity"] = activity["quantity"]
      activity_hash["units"] = activity["measurement"]
      unless activity["procedures"].nil?
        children = []
        activity["procedures"].each { |child_index, child|
          child_hash = Hash.new
          child_hash["activity_id"] = child["id"]
          child_hash["quantity"] = child["quantity"]
          child_hash["units"] = child["measurement"]
          children << child_hash
        }
        activity_hash["children"] = children
      end
      assembly["children"] << activity_hash
    }

    @model = [assembly]
    
    #to see the new hash - this is the one to pass to back-end
    File.open("app/assets/json/model_data_new.json","w") do |f|
      f.write(@model.to_json)
    end
    
    puts "FINAL JSON:"
    puts @model


    if hash == nil
      result = false
      respond_to do |format|
      	format.json { nil.to_json }
      end
    end

    if session[:assembly_id] == nil
      puts "creating assembly for user"
      @assembly = Assembly.create(:user_id => session[:user_id])
      session[:assembly_id] = @assembly.id
    else
        @assembly = Assembly.find(session[:assembly_id])
    end

    @assembly.components = hash
    @assembly.components_json = @model.to_json
    @assembly.name = params[:assembly_name]
    #@assembly.deblob
    result = @assembly.save

    respond_to do |format|
    	format.json { nil.to_json }
    end
    
  end
  
  private
    def model_params
      params.permit(@model)
    end
end
