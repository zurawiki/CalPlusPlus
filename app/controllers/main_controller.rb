class MainController < ApplicationController

  skip_before_filter :authenticate, :only => :welcome

  def welcome
    # TODO if logged in redirect to home
    render
  end

  def calendar
    render
  end
end
