class Component
  include Mongoid::Document
  field :name
  field :description
  field :properties, type: Hash
end