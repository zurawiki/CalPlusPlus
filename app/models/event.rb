class Event < ActiveRecord::Base
  belongs_to :user, :inverse_of => :events
  validates :title, :start, :end, :importance, :user_id, :presence => true
end
