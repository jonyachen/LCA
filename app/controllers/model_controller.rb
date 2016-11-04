class ModelController < ApplicationController
  def index
  	@categories = Material.categories

  	@material_data = Hash[Material.all.collect {|material| [material.title, nil]}]

  	@material_options = Material.categories.collect do |category|
  		[category, Material.find_by_category(category).collect {|material| material.title}]
  	end

   # if @material_options.empty?
   #    @material_options = {'Metals': ["Steel", "Copper"]}
   # end

   render 'index'
  end
end
