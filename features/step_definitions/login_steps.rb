
Given(/^the following Users exist:$/) do |table|
   table.hashes.each do |u|
     User.create(u)
   end
end

Given(/^I am on the signuppage$/) do
  visit signup_path
end

Given(/^I am on the loginpage$/) do
  visit login_path
end

Given(/^I am on the welcomepage$/) do
  visit welcome_path
end

Given(/^I am on the profile page$/) do
  visit profile_path
end

Given(/^I visit my profile$/) do
  visit profile_path
end
