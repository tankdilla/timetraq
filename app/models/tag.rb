class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: String
  
  embedded_in :entry
  has_and_belongs_to_many :activity
  embeds_one :associated_duration
end
