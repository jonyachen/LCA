require 'rails_helper'

RSpec.describe Material, type: :model do
  describe 'Create Material' do
    it 'should create a Material' do
        Material.new(:title => 'Material1').should be_valid
    end
    it 'should create multiple materials' do
        Material.new(:title => 'Model1').should be_valid
        Material.new(:title => 'Model1').should be_valid
    end
    
  end
  
  it 'Creating and finding a material' do
        m = Material.create(:title => 'Material1', :category => "Category1")
        n = Material.create(:title => 'Material2', :category => "Category1")
        Material.find_material('Material1').should == m
  end
        
  
  describe 'Categories'
    it 'is searchable by category' do
        m = Material.create(:title => 'Material1', :category => "Category1")
        n = Material.create(:title => 'Material2', :category => "Category1")
        o = Material.create(:title => 'Material3', :category => "Category2")
        
        Material.where(category: "Category1").should include(m)
        Material.where("category='Category1'").should include(n)
        Material.where("category='Category2'").should include(o)
        
        Material.categories.should include("Category1")
        Material.categories.should include("Category2")
    end
    
  end
  

