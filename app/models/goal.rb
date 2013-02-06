class Goal
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :name
  field :_id, type: String, default: ->{ name }
  field :notes
  field :goal_type #1 = one-time, 2 = recurring, 3 = project-based
  field :project_id, default: nil
  field :started_on, type: Date
  field :target_completion_date, type: Date
  field :completed_ind, type: Boolean
  field :completed_on, type: Date
  field :tracked_activity_ids, type: Array, :default=>[]
  field :referenced_subgoal_ids, type: Array, :default=>[]
  field :referenced_by_super_goal_ids, type: Array, :default=>[]
  field :tag_ids, type: Array, :default=>[]
  
  field :goal_amount_score     #goal score for tracked activities
  field :goal_amount_duration
  field :goal_amount_unit  #days, hours, minutes, points
    
  field :goal_frequency_unit #days, hours, minutes
  field :goal_frequency
  
  embedded_in :user
  
  scope :in_progress, where(:completion_date.exists => false)
  scope :completed, where(:completion_date.exists => true)
  
  validates_presence_of :started_on
  validates_presence_of :goal_type
  #validates_presence_of :goal_amount_score, :if => Proc.new { |goal| goal.goal_amount_duration.nil? }
  #validates_presence_of :goal_amount_duration, :if => Proc.new { |goal| goal.goal_amount_score.nil? }
  
  validates_uniqueness_of :name
  
  #validates_numericality_of :goal_amount_score, :allow_blank? => true
  #validates_numericality_of :goal_amount_duration, :allow_blank? => true
  
  before_create :set_custom_id
  before_save :set_default_values
  
  scope :on, ->(date){ where(:start_time.gte => date).where(:start_time.lte => date+1.day) }
  scope :since, ->(date){ where(:start_time.gte => date)}
  
  scope :from, ->(date){ where(:started_on.gte => date)}
  scope :through, ->(date){ where(:started_on.lte => date)}
  
  scope :non_project, exists(project_id: false)

  def set_custom_id
    #if !self._id.nil?
      self._id = name.gsub(" ", "_")
    #end
  end
  
  def set_default_values
    if self.goal_type == 1
      self.goal_frequency_unit = nil
      self.goal_frequency = nil
      self.goal_frequency_starting_on = nil
    end

    if self.project_id.blank?
      self.project_id = nil
    end
  end
  
  def tracked_activities
    user.activities.in(id: tracked_activity_ids)
  end
  
  def untracked_activities
    user.activities.nin(id: tracked_activity_ids)
  end
  
  def entries(from_date=nil, thru_date=nil)
    #Because of the way i am storing the activities (not embedded or referenced), 
    # this method collects entries for tracked activities.
    e = 
      if from_date.nil? && thru_date.nil?
        tracked_activities.collect{|a| a.entries}
      else
        if thru_date.nil?
          tracked_activities.collect{|a| a.entries.for_dates(from_date, Date.today)}
        else    
          tracked_activities.collect{|a| a.entries.for_dates(from_date, thru_date)}
        end
      end
    
    e.flatten
  end

  def project #a goal can belong to a project, but goal isn't embedded
    user.projects.find(project_id) unless project_id.blank?
  end

  def track_activity(activity_id)
    self.tracked_activity_ids << activity_id #may only want to store the id
    self.save!
  end

  def untrack_activity(activity_id)
    activity_index = self.tracked_activity_ids.index(activity_id)
    self.tracked_activity_ids.delete_at(activity_index)
    self.save!
  end
  
  def duration(duration_entries=entries)
    minutes = duration_entries.inject(0){|score, entry| score += entry.minutes.to_i}
    hours = duration_entries.inject(0){|score, entry| score += entry.hours.to_i}
    days = duration_entries.inject(0){|score, entry| score += entry.days.to_i}
    
    user.normalize_duration(:days=>days, :hours=>hours, :minutes=>minutes)
  end
  
  def duration_string(duration_hash)
    user.duration_string(duration_hash)
  end
  
  def duration_needed
    current_dur = current_duration
    
    goal_string = ""
    
    case goal_amount_unit
    when "days"
      goal_days = goal_amount_duration
      if current_dur[:days] >= goal_days
        goal_string += "Objective has been met!"
      end
    when "hours"
      goal_hours = goal_amount_duration
      if current_dur[:hours] >= goal_hours
        goal_string += "Objective has been met!"
      end
    when "minutes"
      goal_minutes = goal_amount_duration
      if current_dur[:minutes] >= goal_minutes
        goal_string += "Objective has been met!"
      end
    end
    
    if goal_string != "Objective has been met!"
    
      goal_string = "Objective: #{goal_amount_duration} #{goal_amount_unit}, Current duration: "
      if goal_amount_unit == "days"
        goal_string += "#{current_dur[:days]} days, #{current_dur[:hours]} hours, #{current_dur[:minutes]} minutes"
      elsif goal_amount_unit == "hours"
        goal_string += "#{current_dur[:hours]} hours, #{current_dur[:minutes]} minutes"
      elsif goal_amount_unit == "minutes"
        goal_string += "#{current_dur[:minutes]} minutes"
      end
    end
    
    goal_string
  end
  
  def current_score(score_entries=entries)
    score_entries.inject(0){|score, entry| score += entry.score}
  end

  def score(from_date, through_date)
    entries(from_date, through_date).inject(0){|score, entry| score += entry.score}
  end
  
  def points_needed
    goal_amount_score.to_i - current_score
  end
  
  def goal_status
    if !@goal.goal_amount_score.blank?
      unless points_needed <= 0
        "You need #{points_needed} point(s) to reach your goal."
      else
        "Objective has been met!"
      end
    elsif !@goal.goal_amount_duration.blank?
      
      
    end
 
  end
end
