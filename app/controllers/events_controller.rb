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
                   :autoImportance => params[:autoImportance],
                   :user_id => params[:user_id],
                   :location => params[:location]
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
        :autoImportance => params[:autoImportance],
        :user_id => params[:user_id],
        :location => params[:location]
    )
    render :json => event
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    render :json => event
  end

  def edit
    event = Event.find(params[:id])
    event.update_attributes!(
    :allDay => params[:allDay],
    :start => params[:start],
    :end => params[:end],
    :title => params[:title],
    :color => params[:color],
    :importance => params[:importance],
    :user_id => params[:user_id],
    :location => params[:location]
    )
    if params[:importance] == 1.
      event.update_attributes!(
      :autoImportance => false
    )
    end
  end



end
