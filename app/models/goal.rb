class Goal
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :name
  field :summary
  field :goal_type #1 = one-time, 2 = recurring, 3 = project-based
  field :target_completion_date, type: Time
  field :goal_completed_at, type: Time
  field :tracked_activity_ids, type: Array  #may only want to store the id
  
  embedded_in :user
  embedded_in :project
  #embeds_many :activities
  
  validates_presence_of :goal_type
  
  def tracked_activities
    user.activities.in(id: tracked_activity_ids)
  end
  
  def untracked_activities
    user.activities.nin(id: tracked_activity_ids)
  end

  #after_save :create_activities

  #def create_activities
  #  user.activities.each do |ua|
  #    new_activity = activities.collect{|a| a if a.id == ua.id}.compact
  #    if new_activity.blank?
  #      new_activity = Activity.new(ua.attributes)
  #      activities << new_activity
  #    end
  #  end

  #end
end
