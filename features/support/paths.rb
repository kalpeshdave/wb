module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      root_path
    when /the login page/
      login_path
    when /the registration form/
      signup_path
    when /the confirm page with bad token/
      register_path('bad')
    when /the profile page/
      account_path

    when /the contact information page/
      contact_info_path

    when /the contract dashboard page/
      contract_dashboard_path
    when /the contract create page/
      new_contract_path
    when /the contract list page/
      contracts_path
    when /the contract edit page/
      edit_contract_path(@contract)

    when /the reset password page/
      new_password_reset_path
    when /the change password form with bad token/
      edit_password_reset_path('bad')


    when /the companies listing page/
      companies_path

    when /the contract preference page/
      edit_user_contract_preference_path(@user)

    when /the search page/
      search_contracts_path

    when /the template listing page/
      contract_templates_path


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
