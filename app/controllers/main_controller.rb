class MainController < ApplicationController

  skip_before_filter :authenticate, :only => :welcome

  def welcome
    render
  end

  def calendar
    render
  end
end
