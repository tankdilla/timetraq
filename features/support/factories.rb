require 'factory_girl'

FactoryGirl.define do
  factory :user do |f|
    f.name 'user'
    f.email 'user@email.com'
  end
  
  factory :activity do |a|
    a.description 'mow the lawn'
    a.association :user
  end
  
  factory :entry do |e|
    e.note "logging an entry for mowing the lawn"
    e.start_time Time.now
    e.minutes 30
  end
end