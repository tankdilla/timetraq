class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: Integer, :default=>0
  field :_id, type: String, default: ->{ description }
  
  belongs_to :user
  belongs_to :project
  belongs_to :goal
  
  before_create :set_defaults

  def set_defaults
    self._id = description.gsub(" ", "_")
  end
  
  def activities_tagged
    user.activities.collect{|a| a if a.tag_ids.include?(self.id)}.compact
  end

end
