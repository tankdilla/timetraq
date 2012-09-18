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

  embeds_many :activities
  embeds_many :goals
  embeds_many :projects
  embeds_many :tags
  
  before_create :set_defaults
  
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
  
  def digest(as_on=Date.today, summary_period="current_week")
    from_date, through_date = get_digest_dates(as_on, summary_period)
    
    p = projects.where(completion_on: nil).or(completed_on)
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
end
