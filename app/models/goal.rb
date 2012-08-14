class Goal
  include Mongoid::Document
  field :name, type: String
  field :target_completion_date, type: Time
  
  embedded_in :user
  embedded_in :project
  emebeds_many :activities
end
