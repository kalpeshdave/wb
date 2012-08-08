Feature: Manage Contract defaults
  In order to set the default of my contract
  I should be a member of the system.

Scenario: As a member I should be able to see the contract default setting page
  Given "sharon" as an registered member
  And I am on the contract preference page
  And I should see "Contract Defaults"

Scenario: As a member I should be able to set the default contract types
  Given "sharon" as an registered member
  And I am on the contract preference page
  And I check "Allow TimeSheets"
  And I check "Allow Expenses"
  And I check "Require Timesheet Signature"
  And I check "Require Expense Approval"
  And I check "Auto-number Contracts"
  And I fill in "Contract Prefix" with "DINZ11"
  And I fill in "Last Contract Number" with "000IBM1700"
  And I press "Save"
  Then I should see "Contract preferences is updated successfully"

Scenario: As a member I should be able to set the default timesheets
  Given "sharon" as an registered member
  And I am on the contract preference page
  And I select "Month" from "Timesheets entered each"
  And I select "Day" from "Time Unit"
  And I fill in "Default Value" with "23.33"
  And I press "Save"
  Then I should see "Contract preferences is updated successfully"

Scenario: As a member I should be able to set the default invoice
  #Given "sharon" as an registered member
#  And I am on the contract preference page
 # And I select "Month" from "Payment Terms"
 # And I fill in "Rate" with "23.22"
 # And I fill in "Unit Quantity" with "224"
 # And I select "USD" from "Currency"
 # And I press "Save"
 # Then I should see "Contract preferences is updated successfully"

