Feature: Search for materials and features

    As a product designer
    So that I can search for materials and processes
    I need to filter materials and processes by text input

Background: Materials and Processes have been added to the database
  
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


Scenario: Search for Materials
  Given I am on the homepage
  When I fill in "material-search" with "S"
  Then I should see "Glass"
  And I should see "Steel"
  And I should see "Metal"
  And I should see "Epoxy"