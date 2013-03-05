class Contact
  include Mongoid::Document
  field :name, type: String
  field :email_address, type: String
  #field :user_id, type: Integer
  
  embedded_in :user
  has_many :assignments
end
