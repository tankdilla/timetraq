class Activity
  include Mongoid::Document
  field :description, type: String
  field :_id, type: String#, default: ->{ description } #set this to have a custom id, prettier url 
  
  field :priority, type: Integer

  embedded_in :user
  embeds_many :entries
  has_and_belongs_to_many :tags
 
  before_create :set_defaults

  def set_defaults
    if self._id.nil?
      self._id = description.gsub(" ", "_")
    end
  end
end
