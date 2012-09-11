class Project
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :name, type: String
  field :target_completion_date, type: Time
  field :referenced_subproject_ids, type: Array, :default=>[]
  field :referenced_by_super_project_ids, type: Array, :default=>[]
  field :completed_ind, type: Boolean
  field :completed_on, type: Date
  
  field :tag_ids, type: Array, :default=>[]
  
  embedded_in :user
  
  scope :in_progress, where(:completion_date.exists => false)
  scope :completed, where(:completion_date.exists => true)

  def goals
    @user.goals.where(project_id: id.to_s)
  end
end
