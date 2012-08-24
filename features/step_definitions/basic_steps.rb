Given /^I am at the home page$/ do
  visit root_path
end

When /^I click "(.*?)"$/ do |arg1|
  click_link(arg1)
end

When /^enter a username$/ do
  fill_in('Name', :with => 'user')
end

When /^enter an email$/ do
  fill_in('Email', :with => 'user@email.com')
end

When /^click "(.*?)"/ do |arg1|
  click_button(arg1)
end

Then /^a user should be created successfully$/ do
  User.where(name: 'user').should_not be_nil
end

Then /^I should see "(.+)"$/ do |text|
  page.should have_content(text)
end

Given /^there is a user$/ do
  u = build(:user)
end

When /^I create a new activity$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the user should have an activity$/ do
  pending # express the regexp above with the code you wish you had
end