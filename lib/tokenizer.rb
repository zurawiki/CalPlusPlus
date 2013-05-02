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
      features += [lem.lemma(word.downcase)]
    end
    #tokenize locations
    loc = event.location
    if loc.empty?
      loc = "no_location"
    end

    features += ["loc:#{loc}"]

    #tokenize times
    start_time = event.start
    features += ["start_time:#{start_time}"]

    end_time = event.end
    features += ["end_time:#{end_time}"]
  end



end