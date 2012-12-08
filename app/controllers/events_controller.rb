# Note that to avoid bugs and security issues, we manually specify the parameters we want to save &
# update, rather than just passing them all in.
class EventsController < ApplicationController
  def index
    render :json => Event.all
  end

  def create
    render :json =>
               Event.create!(
                   :allDay => params[:allDay],
                   :start => params[:start],
                   :end => params[:end],
                   :title => params[:title],
                   :color => params[:color],
                   :importance => params[:importance]
               )
  end

  def update
    event = Event.find(params[:id])
    event.update_attributes!(
        :allDay => params[:allDay],
        :start => params[:start],
        :end => params[:end],
        :title => params[:title],
        :color => params[:color],
        :importance => params[:importance]
    )
    render :json => event
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    render :json => event
  end
end
