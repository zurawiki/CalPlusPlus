# encoding: utf-8

class StuffClassifier::Bayes < StuffClassifier::Base
  attr_accessor :weight
  attr_accessor :assumed_probability


  # http://en.wikipedia.org/wiki/Naive_Bayes_classifier
  extend StuffClassifier::Storage::ActAsStorable
  storable :weight, :assumed_probability

  def initialize(name, opts={})
    super(name, opts)
    @weight = opts[:weight] || 1.0
    @assumed_probability = opts[:assumed_probability] || 0.1
  end

  def word_probability(word, category)
    total_words_in_category = total_word_count_in_category(category)
    return 0.0 if total_words_in_category == 0
    word_count(word, category).to_f / total_words_in_category
  end


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

  def doc_probability(text, category)
    @tokenizer.each_word(text).map { |w|
      word_weighted_average(w, category)
    }.inject(1) { |p, c| p * c }
  end

  def text_probability(text, category)
    category_probability = category_count(category) / total_category_count
    doc_probability = doc_probability(text, category)
    category_probability * doc_probability
  end

  def category_scores(text)
    probabilitys = {}
    categories.each do |cat|
      probabilitys[cat] = text_probability(text, cat)
    end
    probabilitys.map { |k, v| [k, v] }.sort { |a, b| b[1] <=> a[1] }
  end


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
      h[cat]=text_probability(word, cat); h
    end
    p result


  end

end
