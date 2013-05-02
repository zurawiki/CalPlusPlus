require 'lemmatizer'

class StuffClassifier::Tokenizer
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
    location = (event.location.nil?) ? 'none' : event.location

    features += ["location:#{location}"]

    #tokenize times
    start_time = event.start
    features += ["start_t:#{start_time}"]

    end_time = event.end
    features += ["start_t:#{end_time}"]
  end


end