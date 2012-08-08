Feature: Password Reset
  As a user who forgot her password
  I want to reset my password
  So that I can continue using the site

  Scenario: Display a reset password form
    Given I am on the home page
    When I go to the reset password page
    Then I should see a reset password form

  Scenario: Send a reset instructions email if given a valid email
    Given "sharon" a confirmed user with email "sharon@example.com"
    When I go to the reset password page
    And I fill in "email" with "sharon@example.com"
    And I press "Reset Password"
    Then I should receive an email with subject "Password Reset Instructions"
    When I open the email

  Scenario: Do not send a reset instructions email if given an invalid email
    Given "sharon" a confirmed user with email "sharon@example.com"
    When I go to the reset password page
    And I fill in "email" with "unknown@example.com"
    And I press "Reset Password"
    Then "unknown@example.com" should receive no emails
    And I should see "No user was found with that email address"

  Scenario: Display change password form with valid token
    Given "sharon" a confirmed user with email "sharon@example.com"
    When I go to the reset password page
    And I fill in "email" with "sharon@example.com"
    And I press "Reset Password"
    And I open the email
    Then I should receive an email with subject "Password Reset Instructions"
    
  