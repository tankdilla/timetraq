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
  @user.activities.count.should == 1
end

When /^the user logs an entry called "(.*?)" for activity "(.*?)" for (\d+) minutes$/ do |entry_desc, activity_desc, minutes|
  create(:entry, :note=>entry_desc, :minutes=>minutes, :activity => @user.activities.first)
end

When /^I visit the activity show page$/ do
  visit(user_activity_path(@user, @user.activities.first))
end

Given /^the user creates a tag called "(.*?)" with a score of (\d+)$/ do |tag_desc, tag_score|
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

Given /^the activity is tagged as "(.*?)"$/ do |arg1|
  steps %{
    Given the user creates a tag called "productive" with a score of 1
    When I tag the activity "Doing productive work" with "#{arg1}" 
    }
end

Then /^the entry should have a default score of (\d+)$/ do |arg1|
  @user.activities.first.entries.first.score.should == 2
end
