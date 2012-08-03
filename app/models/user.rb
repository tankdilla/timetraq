class User
  include Mongoid::Document
  field :name, type: String
  field :email, type: String

  embeds_many :activities
  embeds_many :tags
  
  def current_day_activities
    activities
  end

  def current_day_entries
    activities.collect{|a| a.entries}.flatten
  end
end
