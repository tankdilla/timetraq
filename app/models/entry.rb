class Entry
  include Mongoid::Document
  field :note, type: String
  field :score, type: Integer
  field :minutes, type: Integer
  field :hours, type: Integer
  field :days, type: Integer
  field :start_time, type: DateTime
  field :end_time, type: DateTime

  embedded_in :activity
  has_and_belongs_to_many :tags

  validates_presence_of :note, :start_time
end
