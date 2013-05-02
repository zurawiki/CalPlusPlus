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
    color = "#"+ ("%06x" % (rand * 0xffffff))

    events.each do |event|
      puts @classifier
      importance = @classifier.classify event.summary || 0
      begin
        Event.create!(
            :allDay => false,
            :start => event.start.dateTime,
            :end => event.end.dateTime,
            :title => event.summary,
            :color => color,
            :importance => importance,
            :autoImportance => true,
            :user_id => @user.id,
            :location => event.location
        )
      rescue
        logger.warn "Found an all day event"
        Event.create!(
            :allDay => true,
            :start => Date.parse(event.start.date),
            :end => (Date.parse(event.end.date)-1),
            :title => event.summary,
            :color => color,
            :importance => importance,
            :autoImportance => true,
            :user_id => @user.id,
            :location => event.location
        )

      end
    end
    redirect_to root_url, :notice => "Successfully imported Calendar: #{@result.data.summary}"
  end

  def train
    category = params[:category]
    events = get_calendar_events

    events.each do |event|
      item = Event.create(
          :allDay => true,
          :start => Date.parse(event.start.date),
          :end => (Date.parse(event.end.date)-1),
          :title => event.summary,
          :color => color,
          :importance => 0,
          :autoImportance => true,
          :user_id => @user.id
      )
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
