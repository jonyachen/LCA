Feature: display homepage
  
    As a product designer
    So that I can see features available in the program
    I want to see a homepage with various buttons and functions
    
Background: I am on the LCA app homepage
  
    Given I am on the homepage
  
Scenario: Visit the homepage
    When I am on the homepage
    Then I should see "+Material"
    And I should see "+Sub-Assembly"
    And I should see "Something"