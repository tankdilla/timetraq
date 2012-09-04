require 'factory_girl'

FactoryGirl.define do
  sequence :name do |u|
    "user#{u}"
  end

  factory :user do |f|
    name
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
    e.association :activity
  end

  factory :tag do |t|
    t.description "Good"
    t.classification 1
    t.association :user
  end
end
