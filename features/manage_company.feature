Feature:
  In order to manage user's company information
  I should have an account
  And I should be able to view all company and a add company for user.

  Scenario: As a member I should be able to see the contact information option
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Select Company"

  Scenario: As a member I should be able to go to contact information page.
  Given "sharon" as an registered member
  When I am on the profile page
  Then I should see "Select Company"
  When I follow "Select Company"
  Then I should see the companies listing page

  Scenario: As a member I should be able to go to contact information page.
  Given "sharon" as an registered member
  When I am on the companies listing page
  And I follow "Add"
  Then I should see the new company form

  Scenario: As a user, I should be able to Create any number of companies with valid info
  Given "sharon" as an registered member
  When I am on the companies listing page
  And I follow "Add"
  And I fill in "company_name" with "XYZ Pvt. Ltd."
  And I fill in "company_url" with "www.xyz.com"
  And I fill in "company_address_attributes_address_description" with "Xyz Ltd, 1st Floor"
  And I fill in "company_address_attributes_address_1" with "Single Junction"
  And I fill in "company_address_attributes_address_2" with "S.G Road, New Mart Road"
  And I fill in "company_address_attributes_city" with "Ahmedabad"
  And I fill in "company_address_attributes_zipcode" with "385686"
  And I fill in "company_address_attributes_state" with "Gujrat"
  And I select "India" from "company_address_attributes_country"
  And I press "Save"
  Then I should see "Company was added successfully!"

  Scenario: As a user, I should not be able to Create company if the input value is invalid
  Given "sharon" as an registered member
  When I am on the companies listing page
  And I follow "Add"
  And I fill in "company_name" with ""
  And I fill in "company_url" with "www.xyz.com"
  And I fill in "company_address_attributes_address_description" with "Xyz Ltd, 1st Floor"
  And I fill in "company_address_attributes_address_1" with "Single Junction"
  And I fill in "company_address_attributes_address_2" with "S.G Road, New Mart Road"
  And I fill in "company_address_attributes_city" with "Ahmedabad"
  And I fill in "company_address_attributes_zipcode" with "385686"
  And I fill in "company_address_attributes_state" with "Gujrat"
  And I select "India" from "company_address_attributes_country"
  And I press "Save"
  Then I should see "Name can't be blank"


  Scenario: As a user, I should be able to relate/Associated to only 1 company

  Scenario: As a user, I should be able to change the company that i am associated with

  Scenario: As a user, i should be able to update the company that i created