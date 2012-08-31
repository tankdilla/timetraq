Feature: Basic Functions
  In order to track how time is spent
  As a user
  I want to enter the activities that I do
  
  Scenario: First time user enters
    Given I am at the home page
    When I click the link "New User"
    And enter a username
    And enter an email
    And I click the button "Save"
    Then a user should be created successfully
    And I should see "User was successfully created"

  Scenario: User enters an activity
    Given there is a user
    And the user has created an activity called "Mowing the lawn"
    When I visit the page for the user
    Then I should see an activity called "Mowing the lawn"
    
  Scenario: User logs an activity entry
    Given there is a user
    And the user has an activity called "Mowing the lawn"
    When the user logs an activity entry called "Mowed the lawn today"
    And I visit the activity show page
    Then I should see an activity entry called "Mowed the lawn today" 