# encoding: utf-8


# Basic Logic for classifiers. This is the parent class for both Bayes classifier and Multinomial classifier.

class StuffClassifier::Base
  extend StuffClassifier::Storage::ActAsStorable
  attr_reader :name
  attr_reader :word_list
  attr_reader :category_list
  attr_reader :training_count

  attr_accessor :tokenizer
  attr_accessor :language

  attr_accessor :thresholds
  attr_accessor :min_prob
  attr_accessor :features


  storable :version, :word_list, :category_list, :training_count, :thresholds, :min_prob

  # opts :
  # language
  # stemming : true | false
  # weight
  # assumed_prob
  # storage
  # purge_state ?

  def initialize(name, opts={})
    @name = name

    # This values are nil or are loaded from storage
    @word_list = {}
    @category_list = {}
    @training_count=0

    # Classifier storage options
    purge_state = opts[:purge_state]
    @storage = opts[:storage] || StuffClassifier::Base.storage
    if purge_state
      @storage.purge_state(self)
    else
      @storage.load_state(self)
    end

    # This value can be set during initialization or overrided after load_state
    @thresholds = opts[:thresholds] || {}
    @min_prob = opts[:min_prob] || 0.0

    @ignore_words = nil

    # Features are used to determine which property of the event we are considering
    # Designed this way to  implement multinomial classifiaction later
    @features = opts[:features] || [:title]

    # Initialize the tokenizer.
    @tokenizer = StuffClassifier::Tokenizer.new()
  end

  # Takes in a training word (token) and update the current record.
  # A new dictionary is created in the word frist appear.
  def increase_word(word, category)
    @word_list[word] ||= {}

    @word_list[word][:categories] ||= {}
    @word_list[word][:categories][category] ||= 0
    @word_list[word][:categories][category] += 1

    @word_list[word][:_total_word] ||= 0
    @word_list[word][:_total_word] += 1


    # words count by categroy
    @category_list[category] ||= {}
    @category_list[category][:_total_word] ||= 0
    @category_list[category][:_total_word] += 1

  end

  # Add a new category
  def increase_category(category)
    @category_list[category] ||= {}
    @category_list[category][:_count] ||= 0
    @category_list[category][:_count] += 1

    @training_count ||= 0
    @training_count += 1

  end

  # Return number of times the word appears in a category
  def word_count(word, category)
    return 0.0 unless @word_list[word] && @word_list[word][:categories] && @word_list[word][:categories][category]
    @word_list[word][:categories][category].to_f
  end

  # Return the number of times the word appears in all categories
  def total_word_count(word)
    return 0.0 unless @word_list[word] && @word_list[word][:_total_word]
    @word_list[word][:_total_word].to_f
  end

  # Return the number of words in a categories
  def total_word_count_in_category(category)
    return 0.0 unless @category_list[category] && @category_list[category][:_total_word]
    @category_list[category][:_total_word].to_f
  end

  # Return the number of training item 
  def total_category_count
    @training_count
  end

  # Return the number of training document for a category
  def category_count(category)
    @category_list[category][:_count] ? @category_list[category][:_count].to_f : 0.0
  end

  # Return the number of time categories in which a word appear
  def categories_with_word_count(word)
    return 0 unless @word_list[word] && @word_list[word][:categories]
    @word_list[word][:categories].length
  end

  # Return the number of categories
  def total_categories
    categories.length
  end

  # Return categories list
  def categories
    @category_list.keys
  end

  # Train the classifier. The event and it's category are required
  def train(category, event)
    puts "Training event #{event}  into category #{category}"
    @tokenizer.tokenize(event, @features).each { |w| increase_word(w, category) }
    increase_category(category)
  end

  # Since were calculating relative probablity in category_scores, we turn them into normalized
  # probablity (0~1, possibilities sum upto 1) for better human-readibility. 
  # e.g. :spam => 0.0002, :ham => 0.0003 is converted into :spam => 0.4, :ham => 0.6
  def normalized_probablities(event)
    scores = category_scores(event)

    sum_probability = 0

    scores.each do |score|
      category, probability = score
      sum_probability = sum_probability + probability
    end

    scores.map! do |score|
      category, probability = score
      probability = probability / sum_probability
      score = category, probability
    end

    scores
  end

  # Classify an event. Takes in additional argument as defualt result in case of ambiguity.
  def classify(event, default=nil)
    puts "Classifying event of text #{event}"
    # Find the category with the highest probability
    max_prob = @min_prob
    best = nil

    scores = category_scores(event)
    puts "Category scores are: #{scores}"
    scores.each do |score|
      cat, prob = score
      if prob > max_prob
        max_prob = prob
        best = cat
      end
    end

    # Return the default category in case the threshold condition was
    # not met. For example, if the threshold for :spam is 1.2
    #
    #    :spam => 0.73, :ham => 0.40  (OK)
    #    :spam => 0.80, :ham => 0.70  (Fail, :ham is too close)

    return default unless best

    # The default value of threshold is arbitrarily set to 1.2 

    threshold = @thresholds[best] || 1.2

    scores.each do |score|
      cat, prob = score
      next if cat == best
      return default if prob * threshold > max_prob
    end

    puts self

    best
  end

  def save_state
    @storage.save_state(self)
  end

  class << self
    attr_writer :storage

    def storage
      @storage = StuffClassifier::InMemoryStorage.new unless defined? @storage
      @storage
    end

    def open(name)
      inst = self.new(name)
      if block_given?
        yield inst
        inst.save_state
      else
        inst
      end
    end
  end
end
