require "lemmatizer"

class MyClassifer

  attr_reader :name
  attr_reader :word_list
  attr_reader :category_list
  attr_reader :training_count

  #weight & assumed_prob are used to smooth the result, used in word_weighted_average

  attr_accessor :weight
  attr_accessor :assumed_prob

  #thresholds are used to check ambiguous estimates.
  attr_accessor :thresholds
  attr_accessor :min_prob


  def initialize(name, opts={})

    @name = name

    #we load from cached classifier if there is a cache. Initialize with parameters otherwise
    if !options[:purge] && (Rails.cache.read @name) != nil
      print "Loaded from Cache"
      Rails.cache.read @name
    else
      @word_list = {}
      @category_list = {}
      @training_count = 0
      @weight = opts[:weight] || 1.0
      @assumed_prob = opts[:assumed_prob] || 0.1
      @thresholds = opts[:thresholds] || {}
      @min_prob = opts[:min_prob] || 0.0
    end
  end

  #each given word is mapped to the specified category, increasing both word_list and category_list
  def add_word(word, category)
    @word_list[word] ||= {}

    @word_list[word][:categories] ||= {}
    @word_list[word][:categories][category] ||= 0
    @word_list[word][:categories][category] += 1

    @word_list[word][:total_word] ||= 0
    @word_list[word][:total_word] += 1

    @category_list[category] ||= {}
    @category_list[category][:total_word] ||= 0
    @category_list[category][:total_word] += 1
  end

  #create a new category
  def add_category(category)
    @category_list[category] ||= {}
    @category_list[category][:count] ||= 0
    @category_list[category][:count] += 1

    @training_count ||= 0
    @training_count += 1
  end

  def word_count(word, category)
    return 0.0 unless @word_list[word] && @word_list[word][:categories] && @word_list[word][:categories][category]
    @word_list[word][:categories][category].to_f
  end

  def total_word_count(word)
    return 0.0 unless @word_list[word] && @word_list[word][:total_word]
    @word_list[word][:total_word].to_f
  end

  def total_word_count_in_category(category)
    return 0.0 unless @category_list[category] && @category_list[category][:total_word]
    @category_list[category][:total_word].to_f
  end

  def category_count(category)
    @category_list[category][:count] ? @category_list[category][:count].to_f : 0.0
  end

  def total_category_count
    @training_count
  end

  def tokenize(string)
    lem = Lemmatizer.new
    lem.lemma(string)
  end

  #train the classifier with a text and corresponding category
  def train(category, text)
    tokenize(text).each { |w| add_word(w, category) }
    add_category(category)
    Rails.cache.write(@name, YAML::dumps)
  end

  def word_probability(word, category)
    total_word_in_cat = total_word_count_in_category(category)
    return 0.0 if total_word_in_cat == 0
    word_count(word, category).to_f / total_word_in_cat
  end

  #perform the bayes formula calculation, the result is smoothed by weight and assumed_probability
  def word_weighted_average(word, category)

    # calculate current probability
    basic_prob = word_probability(word, category)

    # count the number of times this word has appeared in all
    # categories
    totals = total_word_count(word)

    # the final weighted average
    (@weight * @assumed_prob + totals * basic_prob) / (@weight + totals)
  end

  def document_probability(text, category)
    tokenize(text).map { |w|
      word_weighted_average(w, category)
    }.inject(1) do |p, c|
      p * c
    end
  end

  def text_probability(text, category)
    cat_prob = category_count(category) / total_category_count
    doc_prob = document_probability(text, category)
    cat_prob * doc_prob
  end

  def categories
    @category_list.keys
  end

  def category_scores(text)
    probabilities = {}
    categories.each do |cat|
      probabilities[cat] = text_probability(text, cat)
    end
    probabilities.map { |k, v| [k, v] }.sort { |a, b| b[1] <=> a[1] }
  end

  def classify(text)
    max_prob = 0.0
    best = nil

    scores = category_scores(text)
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

    threshold = @thresholds[best] || 1.0

    scores.each do |score|
      cat, prob = score
      next if cat == best
      return default if prob * threshold > max_prob
    end

    best
  end

end