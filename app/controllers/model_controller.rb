class ModelController < ApplicationController
  def index
  	@material_data = Hash[Material.all.collect {|material| [material.title, nil]}] # Change nil to material.id?

  	@material_options = Material.categories.collect do |category|
  		[category, Material.where(category: category).collect {|material| [material.title, material.id]}]
  	end

  	@procedures = Hash[Procedure.categories.collect do |category|
  		[category, Material.all.collect do |material|
  			[material.title, Procedure.where(material: material.title, category: category).collect {|procedure| procedure.title}]
  		end
	  	]
  	end
  	]
    
    render 'index'
  end
end
