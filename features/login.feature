Feature: Authentication
  As a confirmed but anonymous user
  I want to login to the application
  So that I can be productive


  Scenario: Display login form to anonymous users
    Given I am on the homepage
    And I should see "Log In"
    When I follow "Log In"
    Then I should see a login form

  Scenario: Redirect to account page when user is logged in
    Given "sharon" a logged in user

  Scenario: Not allow login of an unconfirmed user
    Given "sharon" a notified but unconfirmed user
    When I go to the login page
    And I fill in "user_session_email" with "sharon@example.com"
    And I fill in "user_session_password" with "secret"
    And I press "Login"
    Then I should see "Your account is not active"

 Scenario: Allow login of a user with valid credentials
    Given "sharon" as an registered member
    