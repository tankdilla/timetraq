class Activity
  include Mongoid::Document
  field :description, type: String
  field :priority, type: Integer
end
