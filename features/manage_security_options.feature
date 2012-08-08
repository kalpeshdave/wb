Feature:
  In order to manage user access
  I should have an account
  And I should be able to access and denie user with there id.

Scenario: As a member I should be able to access security form
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Security Options"


Scenario: As a member I should be able to check allow all to contact me.
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Security Options"
  And I check "Allow All to Contact Me"


Scenario: As a member I should be able to save the my preference
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Security Options"
  And I check "Allow All to Contact Me"
  Then I press "Save"
  Then I should see "Account updated!"

@javascript
Scenario: As a member when I uncheck "allow all to contact me" then I should see "Allow user box"
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should not see "Allow User" within "div.formRight"
  And I uncheck "Allow All to Contact Me"
  Then I should see "Allow User" within "div.formRight"

@javascript
Scenario: As a member I should be able to allow members to contact me
  Given "sharon" as an registered member
  And "Allow All to Contact Me" is unchecked
  And I should see "Allow User" within "div.formRight"
  And I fill in "user_access_list" with "user@example.com"
  And I press "Save"
  Then I should see "Account updated!"
  

Scenario: As a member I should be able to uncheck allow all to contact me.