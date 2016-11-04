When /^I drag "([^"]*)"$/ do |piece|
page.execute_script %Q{
  $(#{piece}).simulateDragSortable({move: -4});
}
end
