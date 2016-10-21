require 'rails_helper'

RSpec.describe Procedure, type: :model do
  describe 'Create Precedure' do
    it 'should create a Procedure' do
        Procedure.new(:title => 'Big Part').should be_valid
    end
    it 'should create multiple Procedures' do
        Procedure.new(:title => 'Big Part2').should be_valid
        Procedure.new(:title => 'Big Part3').should be_valid
    end
    
  end
  
  it 'Creating and finding a procedure' do
        part = Procedure.create(:title => 'Big pro2')
        Procedure.find_procedure('Big Pro2').should == part
  end
end
