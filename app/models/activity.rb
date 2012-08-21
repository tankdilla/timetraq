class Activity
  include Mongoid::Document
  field :description
  field :_id, type: String, default: ->{ description }
  #field :priority, type: Integer
  
  field :tag_ids, type: Array, :default=>[]
  
  field :goal_score
  field :goal_duration
  
  validates_uniqueness_of :description, :message => "has already been entered"

  embedded_in :user
  embeds_many :entries
  embeds_many :components
  #embeds_many :execution_steps
  
  scope :with_goals, where(:goal_score.exists => true)

  before_create :set_defaults

  def set_defaults
    #if !self._id.nil?
      self._id = description.gsub(" ", "_")
    #end
  end
  
  def allows_components?
    false #logic here to determine whether to show component-related links
  end
  
  def activity_score
    #score based on tags
    score = 0
    
    tags = user.tags.in(id: tag_ids)
    tags.each{|t| score += t.classification}

    score
  end

  def goals_tracking_this_activity
    if !@user.goals.blank?
      @user.goals.collect{|g| g if g.tracked_activity_ids.include?(self.id)}.compact
    else
      []
    end
  end
  
  def add_to_goal(goal_id)
    goal = @user.goals.find(goal_id)
    unless goal.nil?
      goal.track_activity(self.id)
    end
  end

  def tracked_by_goal?
    !goals_tracking_this_activity.blank?
  end
  
  def goal_entries(goal_id)
    entries.where(toward_goal: goal_id).entries
  end
end
