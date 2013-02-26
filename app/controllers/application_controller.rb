class ApplicationController < ActionController::Base
  protect_from_forgery

  def find_user
    @user = User.where(id: params[:user_id]).first
  end
  
end
