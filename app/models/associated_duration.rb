class AssociatedDuration
  include Mongoid::Document
  field :description, type: String
  field :number_of_minutes, type: Integer
  field :number_of_hours, type: Integer
  field :number_of_days, type: Integer
  field :start_time, type: Time
  field :end_time, type: Time
  
  scope :today, where(:start_time.gte =>  Date.today, :end_time.lte <= Date.today)) }
end
