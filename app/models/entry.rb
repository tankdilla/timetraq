class Entry
  include Mongoid::Document
  field :note, type: String
  field :score, type: Integer

  embedded_in :activity
  embeds_one :associated_duration
  embeds_many :tags
end
