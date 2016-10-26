Feature: Load materials from creation panel into Parts table
  
  As a product designer
  So I can add parts to my model
  I want to add materials to my model table
  
Background: On Homepage
  Given I am on the homepage
	
Scenario: Add material
  When I press "+Material"
  And I enter "Steel" with 32 kg
  And I press "Add"
  Then I should see "Steel"
  And I should see "32 kg"
  
Scenario: Add multiple materials
  When I press "+Material"
  And I enter "Steel" with 32 kg
  And I press "Add"
  Then I press "+Material"
  And I enter "Glass" with 5 kg
  And I press "Add"
  Then I should see "Steel"
  And I should see "32 kg"
  And I should see "Glass"
  And I should see "5 kg"
  
Scenario: Cancel an add
  When I press "+Material"
  And I enter "Steel" with 32 kg
  And I press "Cancel"
  Then I should not see "Steel"
  