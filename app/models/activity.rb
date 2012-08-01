class Activity
  include Mongoid::Document
  field :description, type: String
  field :priority, type: Integer

  embedded_in :user
  embeds_many :entries
  embeds_many :tags
  embeds_one :associated_duration
  
end
