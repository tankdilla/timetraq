class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: String

  embedded_in :activity
  embedded_in :entry
  embeds_many :associated_durations
end
