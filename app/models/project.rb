class Project
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :name, type: String
  field :target_completion_date, type: Time
  field :referenced_subproject_ids, type: Array, :default=>[]
  field :referenced_by_super_project_ids, type: Array, :default=>[]
  
  embedded_in :user

  def goals
    @user.goals.where(project_id: id.to_s)
  end
end
