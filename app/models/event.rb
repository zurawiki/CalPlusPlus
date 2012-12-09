class Event < ActiveRecord::Base
  belongs_to :user, :inverse_of => :events
  validates :title, :start, :end, :presence => true
end
