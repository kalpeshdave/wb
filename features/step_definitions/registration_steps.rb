Given /^"([^"]*)" an unconfirmed user$/ do |name|
    Given "I am on the homepage"
    And "I should see \"Register\""
    When "I go to the registration form"
    And "I fill in \"user_first_name\" with \"#{name}\""
    And "I fill in \"user_last_name\" with \"#{name}\""
    And "I fill in \"user_email\" with \"#{name}@example.com\""
    And "I fill in \"user_password\" with \"secret\""
    And "I fill in \"user_password_confirmation\" with \"secret\""
    And "I check \"user_agreement\""
    And "I press \"Join Whole Books Now\""
   Then "I should have a successful registration"
    And 'I should see "Your account has been created. Please check your e-mail for your account activation instructions!"'
end

Given /^"([^"]*)" a notified but unconfirmed user$/ do |name|
  Given "\"#{name}\" an unconfirmed user"
  And "I should receive an email"
  When "I open the email"
  Then "I should see \"activate your account!\" in the email body"
end

Given /^"([^\"]*)" a confirmed user with email "([^\"]*)"$/ do |name, email|
  Given "I am on the homepage"
  And "I should see \"Register\""
  When "I go to the registration form"
  And "I fill in \"user_first_name\" with \"#{name}\""
  And "I fill in \"user_last_name\" with \"#{name}\""
  And "I fill in \"user_email\" with \"#{email}\""
  And "I fill in \"user_password\" with \"secret\""
  And "I fill in \"user_password_confirmation\" with \"secret\""
  And "I check \"user_agreement\""
  And "I press \"Join Whole Books Now\""
  Then "I should receive an email with subject \"Activation Instructions\""
  When "I open the email"
  And "I follow \"activate your account\" in the email"
  And "I press \"Activate\""
  Then "I should have a successful activation"
end

When /^I fill in the captcha correctly$/ do
  #User.any_instance.stubs(:bypass_humanizer?).returns(true)
end


Then /^I should see the registration form$/ do
  page.should have_content('First name')
  page.should have_content('Last name')
  page.should have_content('Email')
  page.should have_content('Password')
  page.should have_content('Re-Enter Password')
end

Then /^I should have a successful registration$/ do
  And 'I should see "Your account has been created. Please check your e-mail for your account activation instructions!"'
end

Then /^I should see the activation form$/ do
  page.should have_content('Activate')
end


Then /^I should have a successful activation$/ do
  And 'I should see "Your account successfully activated!"'
end

Then /^I should see the home page$/ do
  
end









