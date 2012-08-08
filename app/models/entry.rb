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

  validates_presence_of :start_time
  
  before_save :set_default_score
  
  def duration_string
    string = ""
    
    string += "#{hours} hours" if !hours.nil?
    string += " #{minutes} minutes" if !minutes.nil?
    
    string
  end
  
  def set_default_score
    if self.score.nil?
      self.score = self.activity.priority * multiplier
    end
  end
  
  def multiplier
    multiplier_minutes = 0
    
    if !hours.nil?
      multiplier_minutes = hours * 60
    end
    
    if !minutes.nil?
      multiplier_minutes += mintues
    end
    
    result = multiplier_minutes/15.to_i
    
    [result, 1].max
  end
end
