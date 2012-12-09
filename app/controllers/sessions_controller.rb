class SessionsController < ApplicationController
  def new
    if session[:user_id]
      # our user is logged in
      logger.debug "USER VALIDATED! GOING TO CALENDAR!"
      redirect_to "/cal.html"
    else
      logger.debug "params: #{params.inspect}"
      services = ['google_oauth2']
      links = services.sort.map { |service| "<li style='margin: 15px;'><a href='/auth/#{service}'>#{service}</a></li>" }
      render :text => "Authenticate with: <ul style='font-size: 20pt;'>#{links.join}</ul>", :layout => true
    end
  end

  def create
    @auth = request.env['omniauth.auth']
    if session[:user_id]
      # Means our user is signed in. Add the authorization to the user
      User.find(session[:user_id]).add_provider(@auth)
    else
      # Log him in or sign him up
      auth = Authorization.find_or_create(@auth)
      # Create the session
      session[:user_id] = auth.user.id
    end
    session[:user_token] = @auth["credentials"]["token"]
  end

  def failure
    render :text => "FAILURE :-("
  end

  def destroy
    session[:user_id] = nil
    session[:user_token] = nil

    render :text => "You've logged out!"
  end
end
