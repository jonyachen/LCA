Feature: display panel to add materials
  
    As a product designer
    So that I can add parts to my model
    I want to be able to open a a menu to add materials
    
Background: I am on the LCA app homepage
  
    Given I am on the homepage
  
Scenario: Open the materials panel
    When I press "+Material" 
    Then I should see "Material"
    And I should see "Select your material"
    And I should see "Cancel"
    Then I press "material-cancel"