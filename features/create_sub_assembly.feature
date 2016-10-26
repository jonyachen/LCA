Feature: Create a Sub Assembly with Materials
  
    As a product designer
    So that I can materials to my sub-assembly
    I want to be able to open a menu for sub_assemblies

Background: I am in the Sub-Assembly menu
    Given I am in the "Sub Assembly" menu
    And "Steel" material exists
    
Scenario: Open the sub-assemblies panel
    When I fill in "Name" with "Sub-Assembly12"
    And I fill in "Description" with "A New Sub-Assembly"
    And I press "Steel"
    And I press "Submit"
    
    Then I should see "Sub-Assembly12"