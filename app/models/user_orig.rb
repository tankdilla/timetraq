class User
  include Mongoid::Document
  field :name
  field :_id, type: String, default: ->{ name } #set this to have a custom id, prettier url
  field :email

  embeds_many :activities
  embeds_many :goals
  embeds_many :projects
  embeds_many :tags
  
  before_create :set_defaults

  validates_uniqueness_of :name, :message => "has already been taken"
  
  def set_defaults
    self._id = name.gsub(" ", "_")
  end

  def day_entries(date=Date.today)
    activities.collect{|a| a.entries.from_today.entries}.flatten
  end
  
  def day_score(date=Date.today)
    day_entries.inject(0){|result, entry| result + entry.score}
  end
  
  def day_target(day)
    # get day of the week
    
    # look for preset goals
    # On screen have it say something like: Based on your goals, this is what you should shoot for
    
    # look for entries from prior entries from the same day of the week
    # On screen have it say something like: on average, this is what you usually do
    
  end
end
