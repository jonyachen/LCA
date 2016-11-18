require 'rails_helper'
require 'factory_girl_rails'

RSpec.describe User, type: :model do
  describe 'Create users' do
    it 'should create a User' do
      User.new(:name => 'Daniel Mockaitis', :username => 'dm1234', :password => 'secretword', :email => 'dm7@x.com').should be_valid
    end

    it 'should multiple user factory valid' do
      User.new(:name => 'Daniel Mockaitis', :username => 'dm1234', :password => 'secretword', :email => 'dm3@x.com').should be_valid
      User.new(:name => 'Daniel2 Mockaitis2', :username => 'dm12345', :password => 'secretword2', :email => 'dm2@x.com').should be_valid
    end

  end

  it 'Calling User.authenticate with a valid user/password combo returns a user' do
      alice = User.new(:username => 'alice', :password => 'greatest', :email => 'dm4@x.com', :name => 'alice')
      alice.save!
      User.authenticate('alice', 'greatest').should == alice
      alice.delete()
  end

end
