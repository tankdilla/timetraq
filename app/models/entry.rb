class Entry
  include Mongoid::Document
  field :note, type: String
  field :score, type: Integer
  field :number_of_minutes, type: Integer
  field :number_of_hours, type: Integer
  field :number_of_days, type: Integer
  field :start_time, type: Time
  field :end_time, type: Time

  embedded_in :activity
  
end
