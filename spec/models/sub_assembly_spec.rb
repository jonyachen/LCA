require 'rails_helper'

RSpec.describe SubAssembly, type: :model do
  describe 'Create Sub Assembly' do
    it 'should create a Sub Assembly' do
        SubAssembly.new(:title => 'Big Assembly').should be_valid
    end
    it 'should multiple Sub Assembly creations' do
        SubAssembly.new(:title => 'Big Assembly').should be_valid
        SubAssembly.new(:title => 'Big Assembly').should be_valid
    end
    
  end
  
  it 'Creating and finding a part' do
        sa = SubAssembly.create(:title => 'Assembly 1')
        SubAssembly.find_sub_assembly('Assembly 1').should == sa
  end
end
