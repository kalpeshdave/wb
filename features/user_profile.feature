Feature: In order to visit my profile
         As a logged in user
	 I want be able to view my profile
	 So that i can be able to edit my profile

  Scenario: Display the profile page after log in a user
            Given "sharon" as an registered member
            When I am on the profile page
            Then I should see "Security Options"

  Scenario: Display the contact information page for a logged in user
             Given "sharon" a logged in user
             When I am on the profile page
             And I follow "Contact Information"
	     Then I should see the contact information page