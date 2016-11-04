Feature: Load materials from creation panel into Assembly table

  As a product designer
  So I can add parts to my model
  I want to add materials to my model table

Background: On Homepage
  Given I am on the homepage

Scenario: Add material
  When I select "Materials"
  And I select "Metals"
  And I drag "Steel"
  Then I should see "Steel"

Scenario: Add multiple materials
  When I click "Materials"
  And I click "Metals"
  And I drag "Steel"
  Then I should see "Steel"
  When I click "Materials"
  And I click "Metals"
  And I drag "Copper"
  Then I should see "Copper"
   Then I should see "Steel"

Scenario: Cancel an add
   When I click "Materials"
   And I click "Metals"
   And I drag "Copper"
   Then I should see "Copper"
   And I click "close"
   Then I should not see "Copper"
