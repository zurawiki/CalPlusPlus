# encoding: utf-8


# Multinomial Classifier. Works well even with multi-dimension features.
# Multinomial classifier utilize the features property to create a series of 
# Bayesian classifiers. It calls each bayes classifier to determine the probability
# for a single feature, and then times returned probablilities together to finalize
# multinomial results

class StuffClassifier::Multi < StuffClassifier::Bayes
  attr_accessor :classifiers

  # Initialize the Multinomial Classifer. 
  def initialize(name, opts={})
    super(name, opts)

    # classifiers is an dictionary that holds a series of bayes classifers based on the 
    # features instance variable.
    @classifiers = {}
    @features.each do |f|
      @classifiers[f] = StuffClassifier::Bayes.new("Importance", :features => [f])
    end
  end

  def train(category, event)

    # Train each single bayes classifer with its corresponding data
    @features.each do |f|
      @classifiers[f].train(category, event)
    end
  end

  def classify(event, default=nil)
    puts "Classifying event of text #{event}"
    # Find the category with the highest probability
    max_prob = @min_prob
    best = nil

    final_probablities = [[:important,1],[:not,1]]
    @features.each do |f| 
      important, notimportant = classifiers[f].normalized_probablities(event)
      final_probablities[0][1] = final_probablities[0][1] * important[1]
      final_probablities[1][1] = final_probablities[1][1] * notimportant[1]
    end
  
    scores = final_probablities
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

    best
  end

end
