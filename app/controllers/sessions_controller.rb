class SessionsController < ApplicationController

  skip_before_filter :authenticate

  def new
    if session[:user_id]
      # our user is logged in
      logger.debug 'USER VALIDATED! GOING TO CALENDAR!'
    else
      logger.debug "params: #{params.inspect}"
    end
    redirect_to root_url, :notice => 'You have successfully logged in!'
  end

  def create
    @auth = request.env['omniauth.auth']
    # Log him in or sign him up
    auth = Authorization.find_or_create(@auth)
    # Create the session
    session[:user_id] = auth.user.id
    session[:user_token] = @auth['credentials']['token']
  end

  def failure
    redirect_to root_url, :alert => 'There was an error authentication with Google. Please try again.'
  end

  def destroy
    session[:user_id] = nil
    session[:user_token] = nil

    redirect_to root_url, :notice => 'You are now logged out!'
  end
end
