Feature: Add sub-assembly

    As a product designer
    So I can organize my parts
    I need to be able to create sub-assembly folders and drag things into them

Background: Materials and Processes have been added to the database

    Given I am on the homepage
    
    Given the following Materials exist:
    | title            | category  |
    | Steel            | Metal     |
    | Copper           | Metal     |
    | Aluminum         | Metal     |
    | Concrete         | Ceramic   |
    | Glass            | Ceramic   |
    | Clay             | Ceramic   |
    | Wood             | Wood      |
    | Acids            | Chemicals |
    | Epoxy            | Polymers  |
    
    Given the following Processes exist:
    | title           | category         | material |
    | Rail            | Transportation   |          |
    | Truck           | Transportation   |          |
    | Boat            | Transportation   |          |
    | Hot Roll        | Manufacturing    | Steel    |
    | Cold Roll       | Manufacturing    | Steel    |
    | Tempering       | Manufacturing    | Steel    |
    
    And I enter "Steel" with 25 kg
    And I enter "Wood" with 10 kg
    And I enter "Copper" with 5 kg

@wip
Scenario: Create a new sub-assembly
   Given I do not see "newAssembly"
   And I should see "+Assembly"
   When I press "+Assembly"
   Then I should see "newAssembly"
   
@wip
Scenario: Add name to sub-assembly
   Given I press "+Assembly"
   And I fill in "assemblyName" with "Assem1"
   Then I should see "Assem1"
   
@wip
Scenario: Drag items into sub-assembly folder 
    Given I press "+Assembly"
    And I fill in "assemblyName" with "Assem1"
    When I drag "Steel" to "Assem1"
    Then I should not see "Steel"