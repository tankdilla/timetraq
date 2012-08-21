class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: Integer, :default=>0
  field :_id, type: String, default: ->{ description }
  
  embedded_in :user
  
  def activities_tagged
    user.activities.collect{|a| a if a.tag_ids.include?(self.id)}.compact
  end

end
