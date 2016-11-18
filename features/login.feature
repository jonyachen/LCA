Feature: Login a User

    As a product designer
    So that I can see my projects
    I want to be able to login.

Background:

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

Scenario: Visit the Welcome Page
    Given I am on the welcomepage
    Then I should see "Login"
    And I should see "Sign Up"
    And I should see "Faludi Design"

Scenario: Visit Login Page

   Given I am on the welcomepage
   And I press "Login"
   Then I should see "Username or email"
   And I should see "Password"
   And I should see "Login"

Scenario: Visit Login Page
   Given the following Users exist:
   | name                | login            | password               |
   | John Snow           | user123          | secet_pass1234         |

   And I am on the loginpage

   Then I fill in "username" with "user123"
   And I fill in "password" with "secet_pass1234"
   And I press "Login"

   Then I should see "Materials"

Scenario: Visit Signup Page
   Given I am on the welcomepage
   And I press "Signup"
   Then I should see "Username"
   And I should see "Full Name"
   And I should see "Confirm Password"
   And I should see "Email"
   And I should see "Password"
   And I should see "Signup"

Scenario: Signup a New User
   Given I am on the welcomepage

   And I fill in "username" with "user1234"
   And I fill in "full_name" with "John Snow"
   And I fill in "email" with "john@knightswatch.net"
   And I fill in "password" with "abcd"
   And I fill in "confirm_password" with "abcd"
   And I press "Signup"

   Then I should see "Materials"
