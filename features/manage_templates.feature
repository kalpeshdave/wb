Feature:
  In order to manage contract templates
  I should have an account
  And I should be able to view all templates to create contract using them.

  Scenario: As a member I should be able to see the contract dashboard page
  Given "sharon" as an registered member
  When I am on the profile page
  And I follow "Contracts"
  Then I should see the contract dashboard page
  And I should see "Create from Template"

  Scenario: As a member I should be able to see the template list
  Given "sharon" as an registered member
  When I am on the profile page
  And I follow "Contracts"
  Then I should see the contract dashboard page
  When I follow "Create from Template"
  Then I should see the template listing page