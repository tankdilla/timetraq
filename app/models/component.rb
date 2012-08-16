class Component
  include Mongoid::Document
  field :name
  field :description
  field :properties, type: Hash
  
  embedded_in :activity
end