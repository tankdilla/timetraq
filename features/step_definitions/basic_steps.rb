Given /^I am at the home page$/ do
  visit root_path
end

When /^I click New User$/ do
  click_link('New User')
end

When /^enter a username$/ do
  fill_in('Name', :with => 'user')
end

When /^enter an email$/ do
  fill_in('Email', :with => 'user@email.com')
end

When /^click Save$/ do
  click_button('Save')
end

Then /^a user should be created successfully$/ do
  User.where(name: 'user').should_not be_nil
end

Then /^I should be on the user show page$/ do
  response.should redirect_to(User.where(name: 'user'))
end