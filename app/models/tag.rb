class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: Integer, :default=>0
  field :_id, type: String, default: ->{ description }
  
  embedded_in :user

end
