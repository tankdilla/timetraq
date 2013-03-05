class Group
  include Mongoid::Document
  field :name, type: String
  field :group_owner_user_id
  
  field :group_member_user_ids, type: Array, :default=>[]
end
