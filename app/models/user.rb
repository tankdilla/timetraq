class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  
  field :confirmation_token
  field :confirmed_at, :type => Time
  field :confirmation_sent_at, :type => Time
  
  field :provider
  field :uid
  
  field :name
  field :_id, type: String, default: ->{ name } #set this to have a custom id, prettier url
  
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid

  #embeds_many :activities
  #embeds_many :goals
  #embeds_many :projects
  #embeds_many :tags
  has_many :projects
  has_many :goals
  has_many :tags
  has_many :activities
  has_many :assignments
  
  has_many :groups
  
  embeds_many :contacts
  
  embeds_one :profile
  
  before_create :set_defaults
  after_create  :create_default_tags
  
  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

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
  
  def get_digest_dates(as_on, summary_period=nil)
    beginning_of_week = as_on.beginning_of_week(:sunday)
    end_of_week = as_on.end_of_week(:sunday)
    
    case summary_period
    when "last_week"
      [beginning_of_week - 1.week, end_of_week - 1.week]
    when "2 weeks ago"
      [beginning_of_week - 2.week, end_of_week - 2.week]
    when "3 weeks ago"
      [beginning_of_week - 3.week, end_of_week - 3.week]
    when "last month"
      [beginning_of_week - 1.month, end_of_week - 1.month]
    else #current week is default
      [beginning_of_week, end_of_week]
    end
  end
  
  def duration(entries)
    minutes = entries.inject(0){|score, entry| score += entry.minutes.to_i}
    hours = entries.inject(0){|score, entry| score += entry.hours.to_i}
    days = entries.inject(0){|score, entry| score += entry.days.to_i}
    
    normalize_duration(:days=>days, :hours=>hours, :minutes=>minutes)
  end
  
  #These methods will eventually go in a module or other class
  def normalize_duration(duration_hash)
    
    days = hours = minutes = 0
    if duration_hash[:minutes] > 60
      hours = duration_hash[:minutes] / 60
      minutes = duration_hash[:minutes] % 60
    else
      minutes = duration_hash[:minutes]
    end
    
    if duration_hash[:hours] > 24
      hours += duration_hash[:hours] / 24
      days = duration_hash[:hours] % 24
    else
      hours += duration_hash[:hours]
    end
    
    if duration_hash[:days]
      days += duration_hash[:days]
    end
    
    {:days=>days, :hours=>hours, :minutes=>minutes}
  end
  
  def duration_string(duration_hash)
    string = ""
    if duration_hash[:days].to_i > 0
      string += "#{duration_hash[:days]} days, "
    end
    
    if duration_hash[:hours].to_i > 0
      string += "#{duration_hash[:hours]} hours, "
    end
    
    #if duration_hash[:minutes].to_i > 0
      string += "#{duration_hash[:minutes]} minutes"
    #end
    
    string
  end
  
  def untracked_activities
    #user.activities.nin(id: tracked_activity_ids)
    
    goal_tracked_activities = goals.map{|g| g.tracked_activity_ids}.flatten.uniq
    activities.nin(id: goal_tracked_activities)
  end
  
  def score_for(date=Date.today, time_period="this_week")

    from_date, through_date = get_digest_dates(date, time_period)
    total_score = projects.inject(0){|score, project| score += project.score(from_date, through_date)}
    total_score += goals.non_project.inject(0){|score, goal| score += goal.score(from_date, through_date)}
    total_score += untracked_activities.inject(0){|score, activity| activity.entries.for_dates(from_date, through_date).inject(0){|score, entry| score += entry.score}}
    total_score
  end

  def score_for_dates(from_date, through_date)
    #total score of projects, goals unrelated to projects, and activities unrelated to goals or projects, over a period of time
    
    activities.inject(0){|total_score, activity| total_score += activity.entries.for_dates(from_date, through_date).inject(0) {|e_score, entry| e_score += entry.score}}
    
  end
  
  def duration_for_dates(from_date, through_date)
    #total duration of projects, goals unrelated to projects, and activities unrelated to goals or projects, over a period of time
    
    sum_hash = {:days=>0, :hours=>0, :minutes=>0}
    
    activities.each do |activity|
      sum_hash[:days] += duration(activity.entries)[:days]
      sum_hash[:hours] += duration(activity.entries)[:hours]
      sum_hash[:minutes] += duration(activity.entries)[:minutes]
    end
    
    normalize_duration(sum_hash)
  end
  
  def demo_data
    #clear user data
    clear_data
    #create initial tags, test activity, goal, project
  end
  
  private
  def clear_data
    projects.destroy_all
    goals.destroy_all
    activities.destroy_all
    tags.destroy_all
    profile.destroy unless profile.nil?
    create_default_tags
  end
  
  def create_default_tags
    tags.create!(description: "Productive", classification: 1)
    tags.create!(description: "Neutral", classification: 0)
    tags.create!(description: "Non-Productive", classification: -1)
  end
  
end
