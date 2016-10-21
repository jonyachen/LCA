require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Create Projects' do
    it 'should create a User' do
        Project.new(:title => 'Big Project', :description => 'Big Awesome Project').should be_valid
    end
    it 'should multiple user factory valid' do
        Project.new(:title => 'Big Project2', :description => 'Big Awesome Project2').should be_valid
        Project.new(:title => 'Big Project3', :description => 'Big Awesome Project3').should be_valid
    end
    
  end
  
  it 'Create and find a Project' do
        proj = Project.create(:title => 'Big Project2', :description => 'Big Awesome Project2')
        Project.find_project('Big Project2').should == proj
  end
end
