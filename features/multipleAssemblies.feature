Feature: Add more than one assemblies

    As a product designer
    So I can have multiple projects
    I need to be able to more than one assembly and switch between them

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
Scenario: Create an assembly and see it in the profile
   Given I create an assembly named "Assembly1"
   And I go to the Profile page
   Then I should see "Assembly1"
   
@wip
Scenario: Create 2 assemblies and see both in the profile
   Given I create an assembly named "Assembly1"
   And I create an assembly named "Assembly2"
   And I go to the Profile page
   Then I should see "Assembly1"
   And I should see "Assembly2"
 
@wip
Scenario: Materials are loaded correctly between assemblies
   Given I create an assembly named "Assembly1" with material "Concrete"
   And I create an assembly named "Assembly2"
   And I go to the Profile page
   Then I should see "Assembly1"
   And I should see "Assembly2"
   Then I click "Assembly1"
   Then I should see "Concrete"
   And I go to the Profile page
   And I click "Assembly2"
   Then I should not see "Concrete"