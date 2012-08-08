class User
  include Mongoid::Document
  field :name, type: String
  #field :_id, type: String, default ->{ name } #set this to have a custom id, prettier url
  field :email, type: String
  

  embeds_many :activities

  def day_entries(date=Date.today)
    #activities.collect{|a| a.entries.collect{|e| e if e.start_time.to_date == date}}.compact.flatten
    activities.collect{|a| a.entries.from_today.entries}.flatten
  end
end
