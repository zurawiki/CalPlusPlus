require 'test_helper'

class TestNaiveBayesClassification < TestBase
  before do
    set_classifier MyClassifer.new("Importance")

    train :important, "meet Sadik"
    train :not, "buy drink"
    train :important, "lunch with Kevin"
    train :not, "go walk"
    train :important, "do math homework"
    train :not, "browse facebook"
  end

  def test_cache
    assert Rails.cache.delete("Importance")
  end

  def test_important
    should_be :important, "meet Chad"
    should_be :important, "dinner with Dev"
    should_be :important, "physics homework"
  end

  def test_not_important
    should_be :not, "look at facebook"
    should_be :not, "go to CVS"
  end

  def test_ambiguous
    # TODO
    should_be :important, "class"
  end

end
