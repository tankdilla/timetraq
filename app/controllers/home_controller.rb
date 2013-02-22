class HomeController < ApplicationController
  def index
    #@users = User.all
    
    session[:day] = Date.today
  end
  
  def guest
    
    sign_out
    session[:day] = Date.today
    guest_user = User.where(name: "guest").first
    if guest_user.nil?
      guest_user = User.new(name: "guest", email: "guest@email.com", password: "123456")
      guest_user.confirmed_at = Date.today
      guest_user.encrypted_password = "123456"
      guest_user.save
    end
    
    guest_user.demo_data
    redirect_to guest_user
  end
end
