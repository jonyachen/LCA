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
  	
  	@material_cat = Hash[Material.categories.collect do |category|
  		#[category, Material.where(category: category).collect {|material| [material.title, material.id]}]
  		[category, Material.all.collect do |material|
  		    			[material.title, Material.where(category: category).collect {|material| [material.title, material.id]}]
  		end
  		]
  	end
  	]

  	@procedures = Hash[Procedure.categories.collect do |category|
  		[category, Material.all.collect do |material|
  			[material.title, Procedure.where(material: material.title, category: category).collect {|procedure| [procedure.title, procedure.id]}]
  		end
	  	]
  	end
  	]
  end

  def create
    hash = params[:build]
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
    result = @assembly.save

    respond_to do |format|
    	format.json { nil.to_json }
    end

  end
end
