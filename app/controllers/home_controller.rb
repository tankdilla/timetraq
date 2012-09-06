class HomeController < ApplicationController
  def index
    @users = User.all
    
    session[:day] = Date.today
  end
end
