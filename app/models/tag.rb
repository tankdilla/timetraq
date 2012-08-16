class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: String
  field :_id, type: String, default: ->{ description }
  
  embedded_in :user
end
