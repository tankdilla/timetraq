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
    Then I should see an "activity" called "Mowing the lawn"
    
  Scenario: User logs an activity entry
    Given there is a user
    And the user has an activity called "Mowing the lawn"
    When the user logs an entry called "Mowed the lawn today" for activity "Mowing the lawn" for 30 minutes
    And I visit the activity show page
    Then I should see an "activity entry" called "Mowed the lawn today"

  Scenario: User creates a tag
    Given there is a user
    And the user creates a tag called "productive" with a score of 1
    When I visit the page for tags index
    Then I should see a "tag" called "productive"

  Scenario: User tags an activity
    Given there is a user
    And the user has created an activity called "Doing productive work"
    And the user has a tag called "productive" with a score of 1
    When I tag the activity "Doing productive work" with "productive"
    And I visit the activity show page
    Then I should see a "tag" called "productive"

  Scenario: User logs an activity entry for a tagged activity
    Given there is a user
    And the user has an activity called "Doing productive work"
    And the activity "Doing productive work" is tagged as "productive"
    When the user logs an entry called "Did something productive" for activity "Doing productive work" for 30 minutes
    Then the entry should have a default score of 2

  Scenario: User creates a goal
    Given there is a user
    When I create a "one-time" goal called "Write test code for timetraq" with a goal score of 10
    And I visit the goal show page
    Then I should see a "goal" called "Write test code for timetraq"
    
  Scenario: Goal tracks activities
    Given there is a user with a "one-time" goal called "Write test code for timetraq" with a goal score of 10
    And the user has an activity called "Write some rspec tests"
    When the goal tracks the activity "Write some rspec tests"
    And I visit the goal show page
    Then I should see an "activity" called "Write some rspec tests"
    
  Scenario: User tracks multiple activity entries toward a goal
    Given there is a user
    And the user has an activity called "Write some rspec tests"
    And the user has an activity called "Write some cucumber tests"
    And the user has a tag called "productive" with a score of 1
    And I tag the activity "Write some rspec tests" with "productive"
    And I tag the activity "Write some cucumber tests" with "productive"
    And I create a "one-time" goal called "Write test code for timetraq" with a goal score of 10
    And the goal tracks the activity "Write some rspec tests"
    And the goal tracks the activity "Write some cucumber tests"
    And the user makes 2 30 minute activity entries for activity "Write some rspec tests"
    And the user makes 1 45 minute activity entries for activity "Write some rspec tests"
    And I visit the goal show page
    Then I should see a "goal score" called "Goal Score: 10"
    And I should see a "current score" called "Current Score: 7"
    And I should see a "summary" called "You need 3 point(s) to reach your goal"

  Scenario: User creates a project
    Given there is a user
    And the user creates a project called "Build something awesome"
    When I visit the project show page
    Then I should see a "project" called "Build something awesome"
  
