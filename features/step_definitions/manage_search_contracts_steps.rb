Then /^I should see the search page$/ do
  
end

Then /^I should see the new search contract form$/ do
  page.should have_content('Date Submitted From')
  page.should have_content('Date Submitted To')
  page.should have_content('Rate From')
  page.should have_content('Rate To')
end

Then /^I should see the place block for search contract$/ do
  page.should have_content('search_contract_new_place_attributes__country')
  page.should have_content('search_contract_new_place_attributes__state')
  page.should have_content('search_contract_new_place_attributes__city')
end

