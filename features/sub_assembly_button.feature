Feature: display panel to arrange sub-assemblies
  
    As a product designer
    So that I can arrange sub-assemblies of parts
    I want to be able to open a a menu to create subassemblies
    
Background: I am on the LCA app homepage
  
    Given I am on the LCA app homepage
  
Scenario: Open the sub-assemblies panel
    When I press '+Sub-Assembly' 
    Then I should see 'Name'
    And I should see 'Description'
    And I should see 'Cancel'
    When I press '+Material'
    Then I should not see 'Name'
    And I should not see 'Description'
    And I should see 'Select your material'
    When I press 'Cancel'
    Then I should not see 'Select your material'
    When I press '+Sub-Assembly'
    Then I press 'Cancel'
    Then I should not see 'Name'