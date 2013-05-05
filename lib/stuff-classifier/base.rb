# encoding: utf-8

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


  storable :version, :word_list, :category_list, :training_count, :thresholds, :min_prob

  # opts :
  # language
  # stemming : true | false
  # weight
  # assumed_prob
  # storage
  # purge_state ?

  def initialize(name, opts={})
    @version = StuffClassifier::VERSION

    @name = name

    # This values are nil or are loaded from storage
    @word_list = {}
    @category_list = {}
    @training_count=0

    # storage
    purge_state = opts[:purge_state]
    @storage = opts[:storage] || StuffClassifier::Base.storage
    unless purge_state
      @storage.load_state(self)
    else
      @storage.purge_state(self)
    end

    # This value can be set during initialization or overrided after load_state
    @thresholds = opts[:thresholds] || {}
    @min_prob = opts[:min_prob] || 0.0


    @ignore_words = nil
    @tokenizer = StuffClassifier::Tokenizer.new()

  end

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

  def increase_category(category)
    @category_list[category] ||= {}
    @category_list[category][:_count] ||= 0
    @category_list[category][:_count] += 1

    @training_count ||= 0
    @training_count += 1

  end

  # return number of times the word appears in a category
  def word_count(word, category)
    return 0.0 unless @word_list[word] && @word_list[word][:categories] && @word_list[word][:categories][category]
    @word_list[word][:categories][category].to_f
  end

  # return the number of times the word appears in all categories
  def total_word_count(word)
    return 0.0 unless @word_list[word] && @word_list[word][:_total_word]
    @word_list[word][:_total_word].to_f
  end

  # return the number of words in a categories
  def total_word_count_in_category(category)
    return 0.0 unless @category_list[category] && @category_list[category][:_total_word]
    @category_list[category][:_total_word].to_f
  end

  # return the number of training item 
  def total_category_count
    @training_count
  end

  # return the number of training document for a category
  def category_count(category)
    @category_list[category][:_count] ? @category_list[category][:_count].to_f : 0.0
  end

  # return the number of time categories in which a word appear
  def categories_with_word_count(word)
    return 0 unless @word_list[word] && @word_list[word][:categories]
    @word_list[word][:categories].length
  end

  # return the number of categories
  def total_categories
    categories.length
  end

  # return categories list
  def categories
    @category_list.keys
  end

  # train the classifier
  def train(category, event)
    puts "Training event of title #{event[:title]} \n into category #{category}"
    @tokenizer.tokenize(event).each { |w| increase_word(w, category) }
    increase_category(category)
    puts "words_in_cat|cat_doc_count\n#{total_word_count(category)}|#{category_count(category)}"
  end

  # classify a text

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

  def classify(event, default=nil)
    puts "Classifying event of title #{event[:title]}"
    # Find the category with the highest probability
    maximum_probability = @min_prob
    best = nil

    scores = normalized_probablities(event)

    puts "Category scores are: #{scores}"
    
    scores.each do |score|
      category, probability = score
      if probability > maximum_probability
        maximum_probability = probability
        best = category
      end
    end

    # Return the default category in case the threshold condition was
    # not met. For example, if the threshold for :spam is 1.2
    #
    #    :spam => 0.73, :ham => 0.40  (OK)
    #    :spam => 0.80, :ham => 0.70  (Fail, :ham is too close)

    return default unless best

    threshold = @thresholds[best] || 1.2

    scores.each do |score|
      category, probability = score
      next if category == best
      return nil if probability * threshold > maximum_probability
    end

    best
  end

  def category_probability (category,event)
    scores = normalized_probablities(event)

    scores.each do |score|
      thiscategory, probability = score
      return probability if thiscategory == category    
    end
    nil
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
