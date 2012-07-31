class Tag
  include Mongoid::Document
  field :description, type: String
  field :classification, type: String
end
