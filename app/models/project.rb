class Project
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Search
  
  field :name, type: String
  field :started_on, type: Date
  field :target_completion_date, type: Time
  field :referenced_subproject_ids, type: Array, :default=>[]
  field :referenced_by_super_project_ids, type: Array, :default=>[]
  field :completed_ind, type: Boolean
  field :completed_on, type: Date
  
  field :viewable
  
  #field :tag_ids, type: Array, :default=>[]
  has_many :tags
  
  #embedded_in :user
  belongs_to :user
  
  scope :in_progress, exists(completion_date: false)
  scope :completed, exists(completion_date: true)
  scope :started, exists(started_on: true)
  
  search_in :name, :tags => :description

  def goals #a project has goals, but not embedded
    user.goals.where(project_id: id.to_s)
  end
  
  def score(from_date, through_date)
    goals.inject(0){|score, goal| score += goal.current_score(goal.entries(from_date, through_date))}
  end
  
  def duration(from_date, through_date)
    #days = hours = minutes = 0
    #goals.each do |goal|
    #  duration_hash = goal.current_duration(goal.entries(from_date, through_date))
    #end
    
    #minutes = goals.inject(0){|score, goal| score += goal.current_duration(goal.entries(from_date, through_date))[:minutes] }
    sum_hash = {:days=>0, :hours=>0, :minutes=>0}
    
    goals.each do |goal|
      sum_hash[:days] += goal.duration(goal.entries(from_date, through_date))[:days]
      sum_hash[:hours] += goal.duration(goal.entries(from_date, through_date))[:hours]
      sum_hash[:minutes] += goal.duration(goal.entries(from_date, through_date))[:minutes]
    end
    
    user.normalize_duration(sum_hash)
  end
  
  def duration_string(duration_hash)
    user.duration_string(duration_hash)
  end
end
