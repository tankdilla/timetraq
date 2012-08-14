class Project
  include Mongoid::Document
  field :name, type: String
  field :target_completion_date, type: Time
  
  embedded_in :user
  embeds_many :goals
end
