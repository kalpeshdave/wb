Feature: Registration
  In order to get my personal account
  As a anonymous user
  I want be able to register
  So that I can be a member of the community

Scenario: Display registration form to anonymous user
  Given I am on the homepage
  And I should see "Register"
  When I follow "Register"
  Then I should see the registration form

Scenario: Allow an anonymous user to create account
  Given I am on the homepage
  And I should see "Register"
  When I follow "Register"
  And I fill in "First name" with "first"
  And I fill in "Last name" with "last"
  And I fill in "Email Address" with "sharon@example.com"
  And I fill in "Password" with "123123"
  And I fill in "Re-Enter Password" with "123123"
  And I check "user_agreement"
  And I fill in the captcha correctly
  And I press "Join Whole Books Now"
  Then I should have a successful registration
  And I should see "Your account has been created. Please check your e-mail for your account activation instructions!"

  Scenario: Send an activation instruction mail at a successful account creation
    Given "sharon" an unconfirmed user
    And I should receive an email
    When I open the email
    Then I should see "activate your account" in the email body

  Scenario: Want to confirm account using mail activation token
    Given "sharon" a notified but unconfirmed user
    When I follow "activate your account!" in the email
    Then I should see the activation form

  Scenario: Do not confirm an account with invalid mail activation token
    Given "sharon" an unconfirmed user
    When I go to the confirm page with bad token
    Then I should see the home page

  Scenario: Activate account using mail activation token with password
    Given "sharon" a notified but unconfirmed user
    When I follow "activate your account!" in the email
    And I press "Activate"
    Then I should have a successful activation
    And I should see "Your account successfully activated!"
    
    