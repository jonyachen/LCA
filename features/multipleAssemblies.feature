Feature: Add more than one assemblies

    As a product designer
    So I can have multiple projects
    I need to be able to more than one assembly and switch between them

Background: Materials and Processes have been added to the database

    Given I am on the homepage
    
    Given the following Users exist:
   | name                | username         | password                | email          |
   | John Snow           | user123          | secret_pass1234         | john@snow.com  |

   And I am on the loginpage

   Then I fill in "username" with "user123"
   And I fill in "password" with "secet_pass1234"
   And I press "Login"

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

Scenario: Create an assembly and see it in the profile
   Given I create an assembly named "Assembly1"
   And I visit my profile
   Then I should see "Assembly1"
   Then I follow "Assembly1"
   Then I should see "Materials"
   
Scenario: Create 2 assemblies and see both in the profile
   Given I create an assembly named "Assembly1"
   And I create an assembly named "Assembly2"
   And I visit my profile
   Then I should see "Assembly1"
   And I should see "Assembly2"