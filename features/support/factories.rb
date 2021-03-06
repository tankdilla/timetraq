require 'factory_girl'

FactoryGirl.define do
  sequence :name do |u|
    "user#{u}"
  end

  factory :user do |f|
    name
    f.email 'user@example.com'
    f.password 'please'
    f.password_confirmation 'please'
    f.confirmed_at Date.today
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
  
  factory :goal do |g|
    g.name "Do something ambitious"
    g.goal_type "one-time"
    g.started_on Time.now
    g.association :user
  end

  factory :project do |p|
    p.name "Do something big"
  end
end
