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
        m = Material.create(:title => 'Material1')
        Material.find_material('Material1').should == m
  end
end
