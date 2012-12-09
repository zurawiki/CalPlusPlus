class Event < ActiveRecord::Base
  validates :title, :start, :end, :presence => true
end
