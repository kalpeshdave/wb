Feature:
  In order to manage user skills
  I should have an account
  And I should be able to add skills with there id.

Scenario: As a member I should be able to see the skill add option
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Skills"

@javascript
Scenario: As a member I should be able to add skill block.
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Skills"
  When I follow "Add" within "div#add_skill"
 