class ModelController < ApplicationController
	skip_before_action :verify_authenticity_token

  def index
    if session[:user_id] == nil
      @user = User.new
      session[:user_id] = @user.id
    else
      @user = User.find(session[:user_id])
    end
    
    if session[:assembly_id] == nil
      @curr_assembly = nil
    else
      @curr_assembly = Assembly.find(session[:assembly_id]).components
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
    
    render 'index'
  end

  def create
    hash = params[:build]
    return false if hash == nil
    
    if session[:assembly_id] == nil
      @assembly = Assembly.new(:user_id => session[:user_id])
      session[:assembly_id] = @assembly.id
    else
      @assembly = Assembly.find(session[:assembly_id])
    end
    
    @assembly.components = hash
    return @assembly.save
  end
end
