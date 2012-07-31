class Entry
  include Mongoid::Document
  field :note, type: String
  field :score, type: Integer
end
