Given /^I have created (\d+) contract with "([^"]*)" and "([^"]*)" names$/ do |number, first_contract, second_contract|
  Factory(:contract, :description => first_contract, :creator => @user)
  Factory(:contract, :description => second_contract, :creator => @user)
end

Given /^I have created "([^"]*)" contract$/ do |contract_name|
  @contract = Factory(:contract, :description => contract_name, :creator => @user)
end

Then /^I should see the contract form$/ do
  page.should have_content('Choose Country')
  page.should have_content('Choose State')
  page.should have_content('Choose City')
  page.should have_content('From')
  page.should have_content('To')
  page.should have_content('Description')
end



