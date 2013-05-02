class ImportController < ApplicationController

  before_filter :connect_google_api

  def list
    @result = @client.execute(
        :api_method => @service.calendar_list.list,
        :parameters => {},
        :headers => {'Content-Type' => 'application/json'}
    )
    render
  end

  def calendar
    events = get_calendar_events

    events.each do |event|
      item = google_event_to_model event
      item.importance = @classifier.classify event
      item.save!
    end
    redirect_to root_url, :notice => "Successfully imported Calendar: #{@result.data.summary}"
  end

  def train
    category = params[:category]
    events = get_calendar_events

    events.each do |event|
      item = google_event_to_model event
      @classifier.train category, item
    end

    redirect_to root_url, :notice => "Successfully trained Calendar: #{@result.data.summary} as type #{category}"

  end

  protected
  def connect_google_api
    @token = session[:user_token]
    @client = Google::APIClient.new
    @client.authorization.access_token = @token
    @service = @client.discovered_api('calendar', 'v3')
  end

  protected
  def google_event_to_model (event)
    color = '#000'
    begin
      item = Event.new(
          :allDay => false,
          :start => event.start.dateTime,
          :end => event.end.dateTime,
          :title => event.summary,
          :color => color,
          :importance => 0,
          :autoImportance => true,
          :user_id => @user.id,
          :location => ''
      )
    rescue => e
      logger.error "Caught exception: #{e}"
      logger.info 'Found an all day event'
      item = Event.new(
          :allDay => true,
          :start => Date.parse(event.start.date),
          :end => (Date.parse(event.end.date)-1),
          :title => event.summary,
          :color => color,
          :importance => 0,
          :autoImportance => true,
          :user_id => @user.id,
          :location => ''
      )
    end
    item.location = event.location unless event.location.nil?

    item
  end

  private
  def get_calendar_events
    calendar = params[:id] #Use the token from the data to request a list of calendars

    @result = @client.execute(
        :api_method => @service.events.list,
        :parameters => {'calendarId' => calendar, 'singleEvents' => 'true'},
        :headers => {'Content-Type' => 'application/json'}
    )

    @result.data.items
  end


end
