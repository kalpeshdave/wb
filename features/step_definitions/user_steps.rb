Given /^"([^"]*)" as an registered member$/ do |user|
  Factory(:standard_contract_type)
  @user = Factory(:user, :first_name => user, :email => "#{user}@example.com")
  And "\"#{user}\" am a logged in member"
  load_default_values
end

Given /^"([^"]*)" am a logged in member$/ do |user|
  @user ||= User.find_by_email("#{user}@example.com")
  When "I go to the login page"
  And "I fill in \"Email Address\" with \"#{@user.email}\""
  And "I fill in \"Password\" with \"secret\""
  And "I press \"Login\""
  Then "I should be logged in"
end

Given /^"([^"]*)" is unchecked$/ do |checkbox|
  user = Factory(:user, :first_name => "neville", :email => "#neville@example.com", :last_name => "vyland")
  @user.user_preference.contact_me = false
  @user.user_preference.save!
  When "I am on the profile page"
end

def load_default_values
  load_time_base
  load_time_unit
end

def load_time_base
  ["Day", "Week", "Month", "Year"].each do |t|
    Factory(:time_base, :name => t)
  end
end

def load_time_unit
  ["15 Min", "30 min", "Hour", "Day", "Week", "Month"].each do |t|
    Factory(:time_unit, :name => t)
  end
end


