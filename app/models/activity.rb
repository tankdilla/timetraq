class Activity
  include Mongoid::Document
  field :description, type: String
  field :priority, type: Integer

  embedded_in :user
  embeds :entries
  embeds :tags
  embeds :associated_durations
  
end
