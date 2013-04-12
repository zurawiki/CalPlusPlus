class ClassifierController < ApplicationController
  module Classifier

    # Takes a single data point and trains the classifier
    # Params:
    # +id+ event id
    # +vector+ data features
    # @return nothing
    def train(id, vector)
    end

    # Returns a probability according to the model of importance
    # Params:
    # +vector+ data features
    def classify(vector)
    end


  end


  class BernoulliClassifier < Classifier

  end
end
