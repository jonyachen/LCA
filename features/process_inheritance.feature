Feature: Smart Processes

    As a product designer
    So I can efficiently add processes
    New processes should assume their parent material's quantities

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


Scenario: Add a process to a quantified material
   Given I am on the homepage
   And I enter "Steel" with 25 kg
   And I drag "Hot Roll" to "Steel"
   Then I should see "Hot Roll 25 kg"
   And I drag "Cold Roll" to "Steel"
   Then I should see "Hot Roll 25 kg"
   And I should see "Cold Roll 0 kg"
   And I should not see "Cold Roll 25 kg"
   
Scenario: Add a process to a non-quantified material
   Given I am on the homepage
   And I enter "Steel" with 0 kg
   And I drag "Hot Roll" to "Steel"
   Then I should see "Hot Roll 0 kg"
   And I drag "Cold Roll" to "Steel"
   Then I should see "Hot Roll 0 kg"
   And I should see "Cold Roll 0 kg"
