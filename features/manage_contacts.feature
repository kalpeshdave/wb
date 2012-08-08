Feature:
  In order to manage user contact information
  I should have an account
  And I should be able to add contacts for user.

Scenario: As a member I should be able to see the contact information option
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Contact Information"


Scenario: As a member I should be able to go to contact information page.
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Contact Information"
  When I follow "Contact Information"
  Then I should see the contact information page

@javascript
Scenario: As a member I should be able to add skill block.
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Contact Information"
  When I follow "Contact Information"
  Then I should see the contact information page
  When I follow "Add" within "div#add_number"