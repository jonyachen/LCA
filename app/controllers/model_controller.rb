class ModelController < ApplicationController
  def index
  	@categories = Material.categories
    
    render 'index'
  end
end
