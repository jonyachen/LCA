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
      params[:new] = nil
      session[:assembly_id] = nil
      @curr_assembly = nil
      @curr_name = nil
    else
      @curr_assembly = Assembly.find(session[:assembly_id]).components
      @curr_name = Assembly.find(session[:assembly_id]).name
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
    #puts "START HASH"
    #puts hash
    #puts "END HASH"
    #hash["0"]["name"] = "test"
    
    #get activity id
    hash.each do |item|
      puts "material"
      puts hash[item]["name"]
      puts hash[item]["id"]
      puts hash[item]["quantity"]
      puts hash[item]["measurement"]
      hash[item]["procedures"].each do |procedure|
        puts "children"
        puts hash[item]["procedures"][procedure]["name"]
        puts hash[item]["procedures"][procedure]["id"]
        puts hash[item]["procedures"][procedure]["quantity"]
        puts hash[item]["procedures"][procedure]["measurement"]
      end
    end
    
    File.open("app/assets/json/model_data.json","w") do |f|
      f.write(hash.to_json)
    end
    
    #to parse
    #file = File.read("app/assets/json/model_data.json")
    #data_hash = JSON.parse(file)
    #data_hash["0"]["name"] = "test"
    #puts "START"
    #puts data_hash
    #puts "END"

    if hash == nil
      result = false
      respond_to do |format|
      	format.json { nil.to_json }
      end
    end

    if session[:assembly_id] == nil
      @assembly = Assembly.create(:user_id => session[:user_id])
      session[:assembly_id] = @assembly.id
    else
        @assembly = Assembly.find(session[:assembly_id])
    end

    @assembly.components = hash #change this to string format to store in json todo
    @assembly.name = params[:assembly_name]
    #@assembly.deblob
    result = @assembly.save

    respond_to do |format|
    	format.json { nil.to_json }
    end

  end
end
