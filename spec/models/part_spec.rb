require 'rails_helper'

RSpec.describe Part, type: :model do
  describe 'Create Parts' do
    it 'should create a Part' do
        Part.new(:title => 'Big Part', :description => 'Big Awesome Part').should be_valid
    end
    it 'should create multiple Parts' do
        Part.new(:title => 'Big Part2', :description => 'Big Awesome Part2').should be_valid
        Part.new(:title => 'Big Part3', :description => 'Big Awesome Part3').should be_valid
    end
    
  end
  
  it 'Creating and finding a part' do
        part = Part.create(:title => 'Big Part2', :description => 'Big Awesome Part2')
        Part.find_part('Big Part2').should == part
  end
end
