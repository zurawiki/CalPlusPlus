class Event < ActiveRecord::Base

  before_save :calculate_importance
  before_create :calculate_importance

  belongs_to :user, :inverse_of => :events
  validates :title, :start, :end, :importance, :user_id, :presence => true

  def calculate_importance
    if self.autoImportance

      good_list = ["test", "meeting", "exam", "final", "project", "due", "important", "essay", "proctor", "game", "match", "tournament", "recital", "concert", "interview"]
      bad_list = ["practice", "class", "lecture", "section", "rehearsal", "seminar"]

      good = {}
      bad = {}

      good_list.each do |word|
        good[word] = true
      end

      bad_list.each do |word|
        bad[word] = true
      end

      # read title
      words = self.title.split(/\W+/)

      score = 0.5;

      words.each do |word|
        word = word.downcase
        if  good[word]
          score += 0.3
        end
        if  bad[word]
          score -= 0.2
        end
      end

      if score > 1
        score = 1
      end
      if score < 0
        score = 0
      end

      self.importance = score

    end
  end
end
