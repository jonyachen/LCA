Feature: Profile Page

    As a product designer
    So that I can see my profile
    I want to see a Profile Tab and be able to view my credentials.

Background: Materials and Processes have been added to the database

   Given the following Users exist:
   | name                | username         | password                | email          |
   | John Snow           | user123          | secret_pass1234         | john@snow.com  |

   And I am on the loginpage

   Then I fill in "username" with "user123"
   And I fill in "password" with "secet_pass1234"
   And I press "Login"

   Then I follow "Profile"

Scenario: Visit Profile Page
   Then I should see "Profile"
   And I should see "Name"
   And I should see "Username"
   And I should see "Email"

   And I should see "John Snow"
   And I should see "user123"
   And I should see "john@snow.com"

Scenario: Should not reveal password
   Then I should see "Profile"
   And I should not see "secret_pass1234"
