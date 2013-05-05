# encoding: utf-8

class StuffClassifier::Bayes < StuffClassifier::Base
  attr_accessor :weight
  attr_accessor :assumed_probability


  # http://en.wikipedia.org/wiki/Naive_Bayes_classifier
  extend StuffClassifier::Storage::ActAsStorable
  storable :weight, :assumed_probability

  # Initialize the Bayes Classifer. 
  # weight and assumed_probablity are used for smoothing.
  def initialize(name, opts={})
    super(name, opts)
    @weight = opts[:weight] || 1.0
    @assumed_probability = opts[:assumed_probability] || 0.1
  end

  # Return the probability of a word's appearence in a given category
  def word_probability(word, category)
    total_words_in_category = total_word_count_in_category(category)
    return 0.0 if total_words_in_category == 0
    word_count(word, category).to_f / total_words_in_category
  end

  # The core function of the classifier. Calculate the weighted probablity using bayes model.
  # Calculate the basic word probablity and smooth it with weight and assumed_probablity. 
  def word_weighted_average(word, category, opts={})
    func = opts[:func]

    # calculate current probability
    basic_probability = func ? func.call(word, category) : word_probability(word, category)

    # count the number of times this word has appeared in all
    # categories
    totals = total_word_count(word)

    # the final weighted average
    (@weight * @assumed_probability + totals * basic_probability) / (@weight + totals)
  end

  # Tokenize the event, calculate weighted probablity for each token in the given category 
  # and multiply them together.
  def doc_probability(event, category)
    @tokenizer.tokenize(event).map { |w|
      word_weighted_average(w, category)
    }.inject(1) { |probability, category| probability * category }
  end

  # Finalize the event's probability by multiplying the doc_probablity 
  # and the category's probablity
  def event_probability(event, category)
    category_probability = category_count(category) / total_category_count
    doc_probability = doc_probability(event, category)
    category_probability * doc_probability
  end

  # Calculate the event's probablity in each category and return an array of the results
  # e.g.[[:spam, 0.0002], [:ham, 0.0003]]
  # To reduce running time, the probablilities are not normalized.
  def category_scores(event)
    probabilities = {}
    categories.each do |category|
      probabilities[category] = event_probability(event, category)
    end
    probabilities.map { |key, value| [key, value] }.sort { |a, b| b[1] <=> a[1] }
  end


  # Debugging function, print out a word's current record in the classifier.
  def word_classification_detail(word)

    p "word_probability"
    result=self.categories.inject({}) do |h, cat|
      h[cat]=self.word_probability(word, cat); h
    end
    p result

    p "word_weighted_average"
    result=categories.inject({}) do |h, cat|
      h[cat]=word_weighted_average(word, cat); h
    end
    p result

    p "doc_probability"
    result=categories.inject({}) do |h, cat|
      h[cat]=doc_probability(word, cat); h
    end
    p result

    p "text_probability"
    result=categories.inject({}) do |h, cat|
      h[cat]=event_probability(word, cat); h
    end
    p result

  end

end
