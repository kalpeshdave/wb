Then /^I should see the new search contractor form$/ do
  page.should have_content('Available Date From')
  page.should have_content('Available Date To')
  page.should have_content('Rate From')
  page.should have_content('Rate To')
end

Then /^I should see the place block for search contractor$/ do
  page.should have_content('search_contractor_new_place_attributes__country')
  page.should have_content('search_contractor_new_place_attributes__state')
  page.should have_content('search_contractor_new_place_attributes__city')
end

Then /^I should see the skill block$/ do
  page.should have_content('search_contractor_new_skill_attributes__name')
  page.should have_content('search_contractor_new_skill_attributes__level_type')
end

Then /^I should see the position block$/ do
  page.should have_content('search_contractor_new_position_attributes__name')
end


