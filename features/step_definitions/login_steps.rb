Then /^I should see a login form$/ do
  page.should have_content('Email')
  page.should have_content('Password')
end


Given /^"([^"]*)" a logged in user$/ do |name|
  Given "\"#{name}\" a confirmed user with email \"#{name}@example.com\""
end

Then /^I should be logged out$/ do
  Then 'I should see "My Profile"'
end

Then /^I should have (\d+) emails at all$/ do |amount|
  amount = 1 if amount == "an"
  mailbox_for(current_email_address).size.should == amount.to_i
end

When /^I open the most recent email$/ do
  open_last_email
end

Then /^I should be logged in$/ do
  #And "I should see \"Login successful!\" within \"div.content\""
  page.should have_content('Login successful')
end


