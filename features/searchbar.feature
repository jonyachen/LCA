Feature: Search for materials and processes

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
  Then "Glass" should be visible.
  And "Steel" should be visible.
  And "Metal" should be visible.
  And "Epoxy" should not be visible.
  And "Chemicals" should not be visible.
  When I fill in "material-search" with "Steel"
  Then "Metals" should be visible.
  And "Ceramics" should not be visible.
  When I clear "material-search"
  Then "Chemicals" should be visible
  And "Metals" should be visible.