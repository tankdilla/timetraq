Feature: Basic Functions
  In order to track how time is spent
  As a user
  I want to enter the activities that I do
  
  Scenario: First time user enters
    Given I am at the home page
    When I click New User
    And enter a username
    And enter an email
    And click Save
    Then a user should be created successfully
    And I should be on the user show page
