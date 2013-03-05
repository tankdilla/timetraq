class Assignment
  include Mongoid::Document
  field :description
  field :_id, type: String, default: ->{ description }
  
  field :tag_ids, type: Array, :default=>[]
  field :assigned_to_email_address
  field :assigned_to_user
  
  validates_uniqueness_of :description, :message => "has already been entered"

  belongs_to :user
  belongs_to :contact
  
  embeds_many :entries
  embeds_many :components
  
  before_create :set_defaults
  
  def set_defaults
    self._id = description.gsub(" ", "_")

    if default_tag = @user.tags.where(classification: 1).first
      self.tag(default_tag.id)
    end
  end

  def allows_components?
    false #logic here to determine whether to show component-related links
  end
  
  def assignment_score
    #score based on tags
    score = 0
    
    tags = user.tags.in(id: tag_ids)
    tags.each{|t| score += t.classification}

    score
  end
  
  def duration(duration_entries=entries)
    minutes = duration_entries.inject(0){|score, entry| score += entry.minutes.to_i}
    hours = duration_entries.inject(0){|score, entry| score += entry.hours.to_i}
    days = duration_entries.inject(0){|score, entry| score += entry.days.to_i}
    
    user.normalize_duration(:days=>days, :hours=>hours, :minutes=>minutes)
  end

  def goals_tracking_this_assignment
    if !user.goals.blank?
      user.goals.collect{|g| g if g.tracked_assignment_ids.include?(self.id)}.compact
    else
      []
    end
  end
  
  def add_to_goal(goal_id)
    goal = user.goals.find(goal_id)
    unless goal.nil?
      goal.track_assignment(self.id)
    end
  end

  def tracked_by_goal?
    !goals_tracking_this_assignment.blank?
  end
  
  def goal_entries(goal_id)
    entries.where(toward_goal: goal_id).entries
  end

  def tag(tag_id)
    tag_ids << tag_id
    #self.save!
  end

  def untag(tag_id)
    tag_index = self.tag_ids.index(params[:tag][:id])
    self.tag_ids.delete_at(tag_index)
    #self.save!
  end
end
