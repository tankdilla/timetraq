class User
  include Mongoid::Document
  field :name, type: String
  field :email, type: String

  embeds_many :activities

  def current_day_activities
    activities
  end
end
