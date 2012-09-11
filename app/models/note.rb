class Note
  include Mongoid::Document
  
  field :note_text
  field :updated_on, :type=>Date
  
  embedded_in :goal
  
  
end