require 'rails_helper'

RSpec.describe Model, type: :model do
  describe 'Create Model' do
    it 'should create a Model' do
        Model.new(:title => 'Model1').should be_valid
    end
    it 'should create multiple Models' do
        Model.new(:title => 'Model1').should be_valid
        Model.new(:title => 'Model1').should be_valid
    end
    
  end
  
  it 'Creating and finding a model' do
        m = Model.create(:title => 'Model1')
        Model.find_model('Model1').should == m
  end
end
