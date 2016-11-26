Background:
   Given the following Users exist:
   | name                | username         | password                | email          |
   | John Snow           | user123          | secret_pass1234         | john@snow.com  |


Scenario: Visit user page
   Given I am on the userprofile page
   Then I should see "John Snow"
   And I should see "Faludi Design"
   And I should see "Projects"
   And I should see "Edit Profile"
