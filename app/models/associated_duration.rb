class AssociatedDuration
  include Mongoid::Document
  field :description, type: String
  field :number_of_minutes, type: Integer
  field :number_of_hours, type: Integer
  field :number_of_days, type: Integer
  field :start_time, type: Time
  field :end_time, type: Time

  scope :today, where.gte(start_time: Date.today)   #simplifying this until I learn mongoid's
    
  embedded_in :tag
  
  def duration_descripiton
    ""
  end
end
