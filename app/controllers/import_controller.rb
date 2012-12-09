class ImportController < ApplicationController

  def list
    if session[:user_id]

      #Use the token from the data to request a list of calendars
      @token = session[:user_token]
      client = Google::APIClient.new
      client.authorization.access_token = @token
      service = client.discovered_api('calendar', 'v3')
      @result = client.execute(
          :api_method => service.calendar_list.list,
          :parameters => {},
          :headers => {'Content-Type' => 'application/json'}
      )
      render

    else
      redirect_to root_url, :notice => "You must be logged in to import calendars"
    end

  end

  def calendar
    if session[:user_id]

      calendar = params[:id] #Use the token from the data to request a list of calendars
      @token = session[:user_token]
      client = Google::APIClient.new
      client.authorization.access_token = @token
      service = client.discovered_api('calendar', 'v3')
      @result = client.execute(
          :api_method => service.events.list,
          :parameters => {'calendarId' => calendar},
          :headers => {'Content-Type' => 'application/json'}
      )

      events = @result.data.items
      color = "#"+ ("%06x" % (rand * 0xffffff))

      events.each do |event|
        begin
          Event.create(
              :allDay => false,
              :start => event.start.dateTime,
              :end => event.end.dateTime,
              :title => event.summary,
              :color => color,
              :importance => 0,
              :autoImportance => true,
              :user_id => @user.id
          )
        rescue
          logger.warn "Found an all day event"
          Event.create(
              :allDay => true,
              :start => Date.parse(event.start.date),
              :end => (Date.parse(event.end.date)-1),
              :title => event.summary,
              :color => color,
              :importance => 0,
              :autoImportance => true,
              :user_id => @user.id
          )
        end
      end
      redirect_to root_url, :notice => "Successfully imported Calendar: "+@result.data.summary

    else
      redirect_to root_url, :notice => "You must be logged in to import calendars"
    end

  end
end
