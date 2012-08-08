Then /^I should see a reset password form$/ do
  page.should have_content('email')
end

Given /^"([^"]*)" a user who opened (?:his|her) reset password email with subject "([^\"]*)"$/ do |name, subject|
  Given "\"#{name}\" a confirmed user with email \"#{name}@example.com\""
  When "I go to the reset password page"
  And "I fill in \"email\" with \"#{name}@example.com\""
  And "I press \"Reset Password\""
  Then "I should receive an email with subject \"#{subject}\""
  When "I open the email"
  Then "I should see \"Reset Password!\" in the email body"
end

Then /^I should see a password modification form$/ do
  response.should contain('Change Password')
  response.should contain('Password')
  response.should contain('Password confirmation')
end

Then /^I should not see a password modification form$/ do
  response.should_not contain('Change Password')
end

