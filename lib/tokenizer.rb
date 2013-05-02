require 'lemmatizer'

class Tokenizer
  #takes an event and returns a list of strings(features)a

  def tokenize(event)
    #prepare lemmatizer
    lem = Lemmatizer.new

    features = Array.new
    #split title, lemmatize words, and add to return list
    words = (event.title).split
    words.each do |word|
      features += lem.lemma(word.downcase)
    end
    #tokenize locations
    loc = event.location
    loc ||= "no_location"

    features += "loc:#{loc}"

    #tokenize times
    start_time = event.start
    start_time ||= "no_start_time"
    features += "start_t:#{start_time}"

    end_time = event.end
    end_time ||= "no_end_time"
    features += "start_t:#{end_time}"
  end



end