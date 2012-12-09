class MainController < ApplicationController

  skip_before_filter :authenticate, :only => :welcome

  def welcome
    if session[:user_id] && User.find(session[:user_id])
      # User is logged in
      redirect_to '/home'
    else
      render
    end
  end

  def calendar
    render
  end
end
