class Event < ActiveRecord::Base

  before_save :calculate_importance
  before_create :calculate_importance

  belongs_to :user, :inverse_of => :events
  validates :title, :start, :end, :importance, :user_id, :presence => true

  def calculate_importance
    if self.autoImportance

      classifier = MyClassifer.new "Importance"

      self.importance = classifier.classify self.title
    end
  end
end
