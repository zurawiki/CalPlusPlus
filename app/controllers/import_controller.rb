class ImportController < ApplicationController

  def list
    client = ImportHelper.initialize_api_client
    @result = client.execute(
        :api_method => service.calendar_list.list,
        :parameters => {},
        :headers => {'Content-Type' => 'application/json'}
    )
    render
  end

  def calendar
    events = ImportHelper.get_google_calendar_events

    color = "#"+ ("%06x" % (rand * 0xffffff))

    events.each do |event|
      begin
        Event.create!(
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
        Event.create!(
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
    redirect_to root_url, :notice => "Successfully imported Calendar: #{@result.data.summary}"

    def train
      category = params[:category]
      classifier = MyClassifer.new "Important"

      events = ImportHelper.get_google_calendar_events

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
        classifier.train category, item
      end

      redirect_to root_url, :notice => "Successfully trained Calendar: #{@result.data.summary} as type #{category}"

    end
  end
end
