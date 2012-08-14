class Goal
  include Mongoid::Document
  field :name, type: String

  field :target_completion_date, type: Time
  
  embedded_in :user
  embedded_in :project
  embeds_many :activities

  after_save :create_activities

  def create_activities
    user.activities.each do |ua|
      new_activity = activities.collect{|a| a if a.id == ua.id}.compact
      if new_activity.blank?
        new_activity = Activity.new(ua.attributes)
        activities << new_activity
      end
    end

  end
end
