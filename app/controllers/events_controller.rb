# Note that to avoid bugs and security issues, we manually specify the parameters we want to save &
# update, rather than just passing them all in.
class EventsController < ApplicationController

  skip_before_filter :authenticate, :only => [:destroy, :create, :update]

  def index
    render :json => @user.events
  end

  def create
    render :json =>
               Event.create!(
                   :allDay => params[:allDay],
                   :start => params[:start],
                   :end => params[:end],
                   :title => params[:title],
                   :color => params[:color],
                   :importance => params[:importance],
                   :user_id => params[:user_id]
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
        :importance => params[:importance],
        :user_id => params[:user_id]
    )
    render :json => event
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    render :json => event
  end
end
