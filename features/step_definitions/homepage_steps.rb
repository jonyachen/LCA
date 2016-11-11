Given(/^I am on the homepage$/) do
  visit root_path
end


Given(/^the following Materials exist:$/) do |table|
   table.hashes.each do |material|
     Material.create(material)
   end
end

Given(/^the following Processes exist:$/) do |table|
   table.hashes.each do |process|
     Procedure.create(process)
   end
end

Then(/^I choose "([^"]*)" from "([^"]*)"$/) do |menu_option, menu|
   within("td[id=#{menu}]") do
      find('.collapsible-header', :text => menu_option).click
   end

end

Then(/^I drag "([^"]*)" to "([^"]*)"$/) do |material, drop_area|
   source = find('.draggable', :text => material)
   target = find("td[id=#{drop_area}]")
   source.drag_to(target)
end
