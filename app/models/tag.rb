class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: String
  
  embedded_in :user
end
