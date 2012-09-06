Given /^I am at the home page$/ do
  visit root_path
end

When /^I click the link "(.*?)"$/ do |arg1|
  click_link(arg1)
end

When /^enter a username$/ do
  fill_in('Name', :with => 'user')
end

When /^enter an email$/ do
  fill_in('Email', :with => 'user@email.com')
end

When /^I click the button "(.*?)"/ do |arg1|
  click_button(arg1)
end

Then /^a user should be created successfully$/ do
  User.where(name: 'user').should_not be_nil
end

Then /^I should see "(.+)"$/ do |text|
  page.should have_content(text)
end

Given /^there is a user$/ do
  @user  = create(:user)
  
  visit '/users/sign_in'
  fill_in "user_email", :with=>@user.email
  fill_in "user_password", :with=>@user.password
  click_button "Sign in"
end

Given /^the user has created an activity called "(.*?)"$/ do |text|
  create(:activity, :description => text, :user=>@user)
end

When /^I visit the page for the user$/ do
  @user.activities.count.should == 1
  visit(user_path(@user))
end

Then /^I should see an? "(.*?)" called "(.*?)"$/ do |item, text|
  page.should have_content(text)
end

Given /^the user has an activity called "(.*?)"$/ do |activity|
  steps %{
    Given the user has created an activity called "#{activity}"
  }
  
  User.count.should == 1
  @user.activities.where(description: activity).count.should == 1
end

When /^the user logs an entry called "(.*?)" for activity "(.*?)" for (\d+) minutes$/ do |entry_desc, activity_desc, minutes|
  activity = @user.activities.where(description: activity_desc).first
  activity.should_not be_nil
  create(:entry, :note=>entry_desc, :minutes=>minutes, :activity => activity)
end

When /^I visit the activity show page$/ do
  visit(user_activity_path(@user, @user.activities.first))
end

Given /^the user (creates|has) a tag called "(.*?)" with a score of (\d+)$/ do |arg1, tag_desc, tag_score|
  create(:tag, :description=>tag_desc, :classification=>tag_score, :user=>@user)
end

When /^I visit the page for tags index$/ do
  visit(user_tag_path(@user, @user.tags.first))
end

Given /^the user has a tag called "(.*?)"$/ do |tag_desc|
  steps %{ Given the user creates a tag called "productive" with a score of 1 }
  @user.tags.where(description: tag_desc).size.should == 1
end

When /^I tag the activity "(.*?)" with "(.*?)"$/ do |activity_desc, tag_desc|
  tag = @user.tags.where(description: tag_desc).first
  activity = @user.activities.where(description: activity_desc).first
  activity.tag(tag.id)
end

Given /^the activity "(.*?)" is tagged as "(.*?)"$/ do |activity_desc, tag_desc|
  steps %{
    Given the user creates a tag called "productive" with a score of 1
    When I tag the activity "#{activity_desc}" with "#{tag_desc}" 
    }
end

Then /^the entry should have a default score of (\d+)$/ do |arg1|
  @user.activities.first.entries.first.score.should == 2
end

When /^I create a "(.*?)" goal called "(.*?)" with a goal score of (\d+)$/ do |goal_type_desc, goal_desc, goal_score|
  create(:goal, :name=>goal_desc, :goal_type=>goal_type_desc, :goal_amount_score=>goal_score, :user=>@user)
end

When /^I visit the goal show page$/ do
  visit(user_goal_path(@user, @user.goals.first))
end

Given /^there is a user with a "(.*?)" goal called "(.*?)" with a goal score of (\d+)$/ do |goal_type, goal_desc, goal_score|
  steps %{
    Given there is a user
    When I create a "#{goal_type}" goal called "#{goal_desc}" with a goal score of #{goal_score}
    }
  @user.goals.count.should == 1
  @user.goals.where(name: goal_desc, goal_amount_score: goal_score).count.should == 1
end

When /^the goal tracks the activity "(.*?)"$/ do |activity_desc|
  activity = @user.activities.where(description: activity_desc).first
  activity.should_not be_nil
  @user.goals.first.track_activity(activity.id)
end

Given /^the user makes (\d+) (\d+) minute activity entries for activity "(.*?)"$/ do |entry_count, entry_duration, activity_desc|
  entry_count.to_i.times do
    steps %{
      And the user logs an entry called "Did: #{activity_desc}" for activity "#{activity_desc}" for #{entry_duration} minutes
    }
  end
  
  activity = @user.activities.where(description: activity_desc).first
  activity.should_not be_nil
  activity.entries.where(note: "Did: #{activity_desc}", minutes: entry_duration).count.should == entry_count.to_i
end

Given /^the user creates a project called "(.*?)"$/ do |project_desc|
  create(:project, :name=>project_desc, :user=>@user)
end

When /^I visit the project show page$/ do
  visit(user_project_path(@user, @user.projects.first))
end



