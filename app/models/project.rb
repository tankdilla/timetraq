class Project
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :start_time, type: Time
  field :days, type: Integer
  field :hours, type: Integer
end
