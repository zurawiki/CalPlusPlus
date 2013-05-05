class ImportController < ApplicationController

  before_filter :connect_google_api
  before_filter :file_storage, :only => [:open, :save]

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
      event.importance = @classifier.classify event
      event.save!
    end
    redirect_to root_url, :notice => "Successfully imported Calendar: #{@calendar_name}"
  end

  def train
    train_events get_calendar_events

    redirect_to root_url, :notice => "Successfully trained Calendar: #{@calendar_name} as type #{@category}"
  end

  def save
    @storage.write get_calendar_events

    redirect_to root_url, :notice => "Successfully cached calendar: #{@calendar_name} to file #{@filename}"
  end

  def open
    train_events @storage.load

    redirect_to root_url, :notice => "Successfully trained Calendar from file #{@filename} as type #{@category}"
  end

  private
  def file_storage
    @filename = params[:filename]

    # open up the file to access
    storage_path = Rails.root.join('tmp').join("training-data-#{@filename}.db")
    @storage = ImportHelper::MiniFileStorage.new(storage_path)
  end

  private
  def train_events (events)
    @category = params[:category]

    events.each do |item|
      @classifier.train @category, item

      item.autoImportance = false
      item.importance = (@category == 'important') ? 1 : 0
      item.save!
    end

    # write new classifier to file
    @classifier.save_state
  end

  private
  def connect_google_api
    token = session[:user_token]
    @client = Google::APIClient.new
    @client.authorization.access_token = token
    @service = @client.discovered_api('calendar', 'v3')
  end

  # TODO remove redundant code
  private
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
          :location => '',
          :description => event.description
      )
    rescue => e
      logger.debug "Caught exception while parsing event: #{e}"
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
          :location => '',
          :description => event.description
      )
    end
    item.location = event.location unless event.location.nil?

    item
  end

  private
  def get_calendar_events
    calendar_id = params[:id] #Use the token from the data to request a list of calendars

    @result = @client.execute(
        :api_method => @service.events.list,
        :parameters => {'calendarId' => calendar_id, 'singleEvents' => 'true'},
        :headers => {'Content-Type' => 'application/json'}
    )

    @result.data.items.map { |event| google_event_to_model event }
  end


end
