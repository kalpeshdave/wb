Feature:
  In order to manage search contractors
  I should have an account
  And I should be able to view all contractors according to search criteria.

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
  And I should see "Search Contractor"

  Scenario: As a member I should be able to see search criteria form for the first time.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contractor"
  Then I should see the new search contractor form

  Scenario: As a member I should be able to create search criteria for the first time.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contractor"
  And I fill in "search_contractor_date_from" with "01/11/2011"
  And I fill in "search_contractor_date_to" with "01/31/2011"
  And I fill in "search_contractor_rate_from" with "2.00"
  And I fill in "search_contractor_rate_to" with "6.00"
  And I press "Save Search Criteria"
  Then I should see "Search Critieria is successfully created."

  Scenario: As a member I should be able to edit search criteria.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contractor"
  And I fill in "search_contractor_date_from" with "01/11/2011"
  And I fill in "search_contractor_date_to" with "01/31/2011"
  And I fill in "search_contractor_rate_from" with "2.00"
  And I fill in "search_contractor_rate_to" with "6.00"
  And I press "Save Search Criteria"
  Then I should see "Search Critieria is successfully created."
  When I follow "Search Contractor"
  And I follow "Search Criteria"
  And I fill in "search_contractor_date_from" with "01/13/2011"
  And I fill in "search_contractor_rate_from" with "3.00"
  And I press "Update Search Criteria"
  Then I should see "Search Critieria successfully updated!"

  @javascript
  Scenario: As a member I should be able to add place block for search contractor.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contractor"
  And I follow "Add" within "div#add_search_place"
  Then I should see the place block for search contractor

  @javascript
  Scenario: As a member I should be able to add skill block for search contractor.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contractor"
  And I follow "Add" within "div#add_search_skill"
  Then I should see the skill block

  @javascript
  Scenario: As a member I should be able to add position block for search contractor.
  Given "sharon" as an registered member
  When I am on the search page
  And I follow "Search Contractor"
  And I follow "Add" within "div#add_search_position"
  Then I should see the position block
