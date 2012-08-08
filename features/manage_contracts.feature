Feature: Manage Contract
  In order to manage contract
  I should be member of the system

Scenario: As a client I should be able to see contract creation form
  Given "sharon" as an registered member
  And I am on the contract create page
  Then I should see "Create Contract" within "div.headingBg"

Scenario: As a client I should be able to view a new contract form
  Given "sharon" as an registered member
  When I am on the contract dashboard page
  And I follow "Create"
  Then I should see the contract form

Scenario: As a client I should be able to create a new contract with valid data
  Given "sharon" as an registered member
  And I am on the contract dashboard page
  When I follow "Create"
  And I should see "New" within "div.headingBg"
  And I fill in "contract_contract_number" with "21"
  And I select "India" from "Choose Country"
  And I fill in "Choose State" with "Maharashtra"
  And I fill in "Choose City" with "Pune"
  And I fill in "From" with "01/06/2011"
  And I fill in "To" with "01/06/2011"
  And I fill in "Description" with "Need to integrate Facebook connectivity"
  And I fill in "contract_long_description" with "Need to integrate Facebook connectivity"
  And I press "Create"
  Then I should see "Contract is successfully created."

Scenario Outline: As a client I should not be able to create a new contract if the input value is invalid
  Given "sharon" as an registered member
  And I am on the contract create page
  And I should see "New" within "div.headingBg"
  And I fill in "contract_contract_number" with ""
  And I select "India" from "Choose Country"
  And I fill in "Choose State" with "Maharashtra"
  And I fill in "Choose City" with "Pune"
  And I fill in "From" with "01/06/2011"
  And I fill in "To" with "01/06/2011"
  And I fill in "Description" with "Need to integrate Facebook connectivity"
  And I fill in "contract_long_description" with "Need to integrate Facebook connectivity"
  And I press "Create"
  Then I should see "Contract number has already been taken"

Scenario: As a client I should be able to see the list of all the contracts
  Given "sharon" as an registered member
  And I have created 2 contract with "Contract one" and "Contract two" names
  When I am on the contract list page
  Then I should see "Contract one"
  And I should see "Contract two"

Scenario: As a client I should be able to edit the contract which is created by me
  Given "sharon" as an registered member
  And I have created "Contract one" contract
  When I am on the contract edit page
  And the "Description" field should contain "Contract one"

Scenario: As a client I should able to post the contract

Scenario: As a client I should be able to see the contract details

Scenario: As a client I should be able to delete the contract which is created by me

Scenario: As a client I should be able to propose a contract to an existing user

Scenario: As a recipient I should be able to approve a contract

Scenario: As a recipient I should be able to reject a contract

Scenario: As a client I can attach multiple file(s) and maintain versions of each file with a contract

Scenario: As a user I should be able to set the Invoice defaults of my contract

Scenario: As a user I should be able to set the Timesheet Defaults of my Contract

Scenario: As a user I can default the numbering of my contracts

Scenario: As a user I should be able to set my Contract Defaults

Scenario: As a user I should be able to create contract defaults

Scenario Outline: As a client I should not be able to create a new contract if the input value is invalid
  Given "sharon" as an registered member
  And I am on the contract create page
  And I should see "New" within "div.headingBg"
  And I select "India" from "Choose Country"
  And I fill in "Choose State" with "<state>"
  And I fill in "Choose City" with "<city>"
  And I fill in "From" with "<start_date>"
  And I fill in "To" with "<end_date>"
  And I fill in "Description" with "<description>"
  And I fill in "contract_long_description" with "<long_description>"
  And I press "Create"
  Then I should see "<error_message>"

  Examples:
  | state       | city  | start_date    | end_date      | description                               |  long_description                         |  error_message                    |
  |             | Pune  | 01/06/2011    | 01/06/2011    | Need to integrate Facebook connectivity   |  Need to integrate Facebook connectivity  |  State can't be blank             |
  | Maharashtra |       | 01/06/2011    | 01/06/2011    | Need to integrate Facebook connectivity   |  Need to integrate Facebook connectivity  |  City can't be blank              |
  | Maharashtra | Pune  |               | 01/06/2011    | Need to integrate Facebook connectivity   |  Need to integrate Facebook connectivity  |  Start date can't be blank        |
  | Maharashtra | Pune  | 01/06/2011    |               | Need to integrate Facebook connectivity   |  Need to integrate Facebook connectivity  |  End date can't be blank          |
  | Maharashtra | Pune  | 01/06/2011    | 01/06/2011    |                                           |  Need to integrate Facebook connectivity  |  Description can't be blank       |
  | Maharashtra | Pune  | 01/06/2011    | 01/06/2011    | Need to integrate Facebook connectivity   |                                           |  Long description can't be blank  |
