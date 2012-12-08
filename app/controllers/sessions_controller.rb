class SessionsController < ApplicationController
  def new
    if session[:user_id]
      # our user is logged in
      logger.debug "USER VALIDATED! GOING TO CALENDAR!"
      redirect_to "/cal.html"
    else
      logger.debug "params: #{params.inspect}"
      services = ['google_oauth2'] # TODO extract from OmniAuth.config
      links = services.sort.map { |service| "<li style='margin: 15px;'><a href='/auth/#{service}'>#{service}</a></li>" }
      render :text => "Authenticate with: <ul style='font-size: 20pt;'>#{links.join}</ul>", :layout => true
    end
  end

  def create
    auth_hash = request.env['omniauth.auth']
    if session[:user_id]
      # Means our user is signed in. Add the authorization to the user
      User.find(session[:user_id]).add_provider(auth_hash)
      render :text => "You can now login using #{auth_hash["provider"].capitalize} too!"
    else
      # Log him in or sign him up
      auth = Authorization.find_or_create(auth_hash)
      # Create the session
      session[:user_id] = auth.user.id
      render :text => "Welcome #{auth.user.name}!"
    end
  end

  def failure
    render :text => "FAILURE :-("
  end

  def destroy
    session[:user_id] = nil
    render :text => "You've logged out!"
  end
end
