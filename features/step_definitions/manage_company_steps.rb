Then /^I should see the companies listing page$/ do
  
end

Then /^I should see the new company form$/ do
  page.should have_content('Name')
end