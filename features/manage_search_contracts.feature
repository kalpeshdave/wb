Feature:
  In order to manage search contracts
  I should have an account
  And I should be able to view all contracts according to search criteria.

  Scenario: As a member I should be able to see the search option
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Search"

  Scenario: As a member I should be able to go to search page.
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Search"
  When I follow "Search"
  Then I should see the search page
  And I should see "Search Contract"

  Scenario: As a member I should be able to see search criteria form for the first time.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contract"
  Then I should see the new search contract form

  Scenario: As a member I should be able to create search criteria for the first time.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contract"
  And I fill in "search_contract_submitted_from" with "01/11/2011"
  And I fill in "search_contract_submitted_to" with "01/31/2011"
  And I fill in "search_contract_rate_from" with "2.00"
  And I fill in "search_contract_rate_to" with "6.00"
  And I press "Save Search Criteria"
  Then I should see "Search Critieria is successfully created."

  Scenario: As a member I should be able to edit search criteria.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contract"
  And I fill in "search_contract_submitted_from" with "01/11/2011"
  And I fill in "search_contract_submitted_to" with "01/31/2011"
  And I fill in "search_contract_rate_from" with "2.00"
  And I fill in "search_contract_rate_to" with "6.00"
  And I press "Save Search Criteria"
  Then I should see "Search Critieria is successfully created."
  When I follow "Search Contract"
  And I follow "Search Criteria"
  And I fill in "search_contract_submitted_from" with "01/13/2011"
  And I fill in "search_contract_rate_from" with "3.00"
  And I press "Update Search Criteria"
  Then I should see "Search Critieria successfully updated!"

  @javascript
  Scenario: As a member I should be able to add place block for search contract.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contract"
  And I follow "Add" within "div#add_search_place"
  Then I should see the place block for search contract

  
  
