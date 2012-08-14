class ApplicationController < ActionController::Base
  protect_from_forgery

  def find_user
    @user = User.find(params[:user_id])
  end
  
end
