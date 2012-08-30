class Goal
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :name
  field :_id, type: String, default: ->{ name }
  field :summary
  field :goal_type #1 = one-time, 2 = recurring, 3 = project-based
  field :project_id
  field :target_completion_date, type: Date
  field :goal_completed_at, type: Date
  field :tracked_activity_ids, type: Array, :default=>[]
  field :referenced_subgoal_ids, type: Array, :default=>[]
  field :referenced_by_super_goal_ids, type: Array, :default=>[]
  field :tag_ids, type: Array, :default=>[]
  
  field :goal_amount_score     #goal score for tracked activities
  field :goal_amount_duration
  field :goal_amount_unit  #days, hours, minutes, points
    
  field :goal_frequency_unit #days, hours, minutes
  field :goal_frequency
  field :goal_frequency_starting_on
  
  embedded_in :user
  embedded_in :project
  
  scope :in_progress, where(:completion_date.exists => false)
  scope :completed, where(:completion_date.exists => true)
  
  validates_presence_of :goal_type
  validates_presence_of :goal_amount_score, :if => Proc.new { |goal| goal.goal_amount_duration.nil? }
  validates_presence_of :goal_amount_duration, :if => Proc.new { |goal| goal.goal_amount_score.nil? }
  
  before_create :set_custom_id
  before_save :set_default_values

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
  end
  
  def tracked_activities
    user.activities.in(id: tracked_activity_ids)
  end
  
  def untracked_activities
    user.activities.nin(id: tracked_activity_ids)
  end
  
  def entries
    tracked_activities.entries.collect{|a| a.entries.where(toward_goal: id.to_s).entries}.flatten
  end

  def project
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
end
