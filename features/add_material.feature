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
  
  
Scenario: Add Material with Sub-Options
  Given "Manufacturing" menu contains "Hot_Rolled" 
  And "Transport" menu contains "Air"
  And "Disposal" menu contains "Landfill"
  
  When I press "+Material"
  And I enter "Steel" with 32 kg
  Then I should see "Edit Material Properties"
  And I should see "Optional Material Processess"
  And I should see "Transport"
  And I should see "Disposal"
  
  Then I select "Hot-Rolled" from menu "Manufacturing"
  And I select "Air" from menu "Transports"
  And I select "Landfill" from menu "Disposal"
  And I press "Add"
  
  Then I should see "Steel"
  And I should see "32kg"
  And I should see "Transport Air"
  
  
  