require 'lemmatizer'

#override Time implementation
class Time
  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end

  def round_to_hour
    self.floor(1.hour)
  end
end

class StuffClassifier::Tokenizer
#takes an event and returns a list of strings(features)

=begin
*Explore ? ! as importance indicators in title/description (more title)
Possible Features
=======================================================
1. Title
2. Description
3. Time (of Day)
4. Weekday
5. Location
6. ALLCAPS?
7. Bin time to quarters of day?

=end

  def tokenize(event, features)
    if features.empty?
      raise ArgumentError, 'No features specified'
    end

    tokens = Array.new

    #Call method responsible for tokenizing a certain feature, append to
    possible_features = [:title, :description, :start_time, :end_time, :weekday, :location]
    features.each { |feature|
      if possible_features.include? feature
        tokens += send(feature, event)
      end
    }
    tokens
  end

  def title(event)
    #splits summary on spaces : " ' | \ /
    #remove ?! or count as importance? ...

    #prepare lemmatizer
    lemmatizer = Lemmatizer.new
    #assumes title is non-optional from GCal
    words = event.title.split(/[\s.:"';\[\]\/-]+/)
    words.map { |word|
      lemmatizer.lemma(word).downcase
    }
  end

  def description(event)
    #prepare lemmatizer
    lemmatizer = Lemmatizer.new

    #splits title on spaces : " ' | \ /
    #remove ? , . ;
    description_string = (event.description.nil?) ? 'none' : event.description
    words = description_string.split(/[\s.:"';\[\]\/-]+/)
    words.map { |word|
      lemmatizer.lemma(word.downcase)
    }
  end

  def start_time(event)
    #bins to hour blocks
    start_time = event.start
    ["start_time " + start_time.strftime("%H")]
  end

  def end_time(event)
    #bins to hour blocks
    end_time = event.end
    ["end_time " + end_time.strftime("%H")]
  end

  def weekday(event)
    ["weekday " + event.start.strftime("%^a")]
  end

  def location(event)
    location = (event.location.empty?) ? 'none' : event.location
    ["location #{location}"]
  end

  #TODO:def exclamation_question(event)
end