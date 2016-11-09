Feature: Assembly FileTree

    As a product designer
    So that I can navigate my existing assemblies
    I need to be able to open an assemblies panel and navigate to assemblies

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

@wip
Scenario: Open Assemblies FileTree
   Given I am on the homepage
   Then I should see "Assemblies"
   And I choose "Materials" from "library"
   Then I should see "Ceramic"
   And I should see "Chemicals"
   And I should see "Metal"
   And I should see "Polymers"
   And I should see "Wood"
   And I should see "Polymers"
   And I should see "Concrete"
