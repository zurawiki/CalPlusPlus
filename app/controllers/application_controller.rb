class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  private
  def authenticate
    if session[:user_id] && User.find(session[:user_id])
      # User is logged in
      @user = User.find(session[:user_id])
      @user_token = session[:user_token]
    else
      # redirect to login
      redirect_to root_url, :notice => "You must be logged in view this page"
    end

  end
end
