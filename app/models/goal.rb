class Goal
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :name
  field :_id, type: String, default: ->{ name }
  field :summary
  field :goal_type #1 = one-time, 2 = recurring, 3 = project-based
  field :project_id
  field :target_completion_date, type: Time
  field :goal_completed_at, type: Time
  field :tracked_activity_ids, type: Array, :default=>[] #may only want to store the id
  
  field :tag_ids, type: Array, :default=>[]
  
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
  
  def entries
    tracked_activities.entries.collect{|a| a.entries.where(toward_goal: id.to_s).entries}.flatten
  end

  def project
    user.projects.find(project_id) unless project_id.nil?
  end
end
