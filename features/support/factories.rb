require 'factory_girl'

FactoryGirl.define do
  factory :user do |f|
    f.name 'user'
    f.email 'user@email.com'
  end
end