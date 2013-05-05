#######
#
# Tokenizer
#
# Functionality: Tokenizes an event in accordance with list of features specified by the caller.
#
# i.e Tokenizer.tokenize(event, [:title, :location]) returns title and location tokens.
#
#######


require 'lemmatizer'

class StuffClassifier::Tokenizer
#takes an event and returns a list of strings(features)

# @param [Event] event
# @param [Symbol Array] features
# @return [String Array]
  def tokenize(event, features)
    if features.empty?
      raise ArgumentError, 'No features specified'
    end

    tokens = Array.new

    # Dynamic method calls: call appropriate private method to tokenize for a certain feature
    possible_features = [:title, :description, :start_time, :end_time, :weekday, :location]

    # Safety check in case user asks for a feature that cannot yet be tokenized
    features.each { |feature|
      if possible_features.include? feature
        tokens += send(feature, event)
      end
    }
    tokens
  end


  private
  # @param [String] string
  # @return [String Array]
  def process_string(string)
    lemmatizer = Lemmatizer.new

    # Split strings by defining delimiters as any combination of:
    #   : " ' ; [ ] / - _ (whitespace) ! ? ,
    words = string.split(/[\s.:"';\[\]\/\-_!?,]+/)
    words.map { |word|
      # Handle proper nouns - we are aware that is is not ubiquitous in coverage
      # e.g. if user enters "james" - will still be lemmatized to "jam"
      case_analysis_string = word.dup
      if case_analysis_string.upcase! == nil
        lemmatizer.lemma(word.downcase)
      elsif word[0].upcase! == nil
        lemmatizer.lemma(word)
      else
        lemmatizer.lemma(word.downcase)
      end
    }
  end

  # @param [Event] event
  # @return [String Array]
  def title(event)
    #assumes title is non-optional from GCal
    process_string(event.title)
  end

  # @param [Event] event
  # @return [String Array]
  def description(event)
    return [] if event.description.nil?
    description_string = event.description
    process_string(description_string)
  end

  # @param [Event] event
  # @return [String Array]
  def start_time(event)
    #bins to hour blocks
    start_time = event.start
    ["start_time " + start_time.strftime("%H")]
  end

  # @param [Event] event 
  # @return [String Array]
  def end_time(event)
    #bins to hour blocks
    end_time = event.end
    ["end_time " + end_time.strftime("%H")]
  end

  # @param [Event] event      
  # @return [String Array]
  def weekday(event)
    ["weekday " + event.start.strftime("%^a")]
  end

  # @param [Event] event
  # @return [String Array]
  def location(event)
    return [] if event.location.empty?
    location = event.location.downcase
    ["location #{location}"]
  end
end