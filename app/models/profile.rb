class Profile
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :hours_worked
  field :hours_sleep
  field :hours_misc
  field :hours_available
  
  embedded_in :user
  
  def goal_worth_per_hour
    user.goals.where(name: "What my time is worth").first.goal_amount_score rescue nil
  end
end  