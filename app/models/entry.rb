class Entry
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :note, type: String
  field :score, type: Integer
  field :minutes, type: Integer
  field :hours, type: Integer
  field :days, type: Integer
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :toward_goal

  embedded_in :activity

  validates_presence_of :start_time
  
  before_save :set_default_score
  
  scope :from_today, gte(start_time: Date.today).lte(start_time: Date.today+1.day)
  scope :on, ->(date){ gte(start_time: date).lte(start_time: date+1.day) }
  scope :since, ->(date){ gte(start_time: date)}
  
  scope :from, ->(date){ gte(start_time: date)}
  scope :through, ->(date){ lte(start_time: date)}
  scope :for_dates, ->(from_date, thru_date){ gte(start_time: from_date).lte(start_time: thru_date)}
  
  def duration_string
    string = ""
    
    string += "#{hours} hours" if !hours.nil?
    string += " #{minutes} minutes" if !minutes.nil?
    
    string
  end
  
  def set_default_score
    if self.score.blank? || self.score == 0
      self.score = self.activity.activity_score * multiplier
    end
  end
  
  def multiplier
    multiplier_minutes = 0
    
    if !hours.nil?
      multiplier_minutes = hours * 60
    end
    
    if !minutes.nil?
      multiplier_minutes += minutes
    end
    
    result = multiplier_minutes/15.to_i
    
    [result, 1].max
  end
end
