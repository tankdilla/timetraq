class Entry
  include Mongoid::Document
  field :note, type: String
  field :score, type: Integer

  embedded_in :activity
  embeds_many :associated_durations
  embeds_many :tags
end
