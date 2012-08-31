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
  create(:user)
end

Given /^the user has created an activity called "(.*?)"$/ do |text|
  create(:activity, :description => text, :user=>User.first)
end

When /^I visit the page for the user$/ do
  User.first.activities.count.should == 1
  visit(user_path(User.first))
end

Then /^I should see an activity called "(.*?)"$/ do |text|
  page.should have_content(text)
end

Given /^the user has an activity called "(.*?)"$/ do |activity|
  Given there is a user
  And the user has created an activity called "{activity}"
end

When /^the user logs an activity entry called "(.*?)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I visit the activity show page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see an activity entry called "(.*?)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end