require 'test_helper'
require 'stuff-classifier'

class TestTokenizer < TestBase
  def test_tokenize_event
    toke = StuffClassifier::Tokenizer.new
    all_features = [:title, :description, :start_time, :end_time, :weekday, :location]
    event1 = Event.new(
        :allDay => false,
        :start => DateTime.parse('3rd Feb 2001 04:06 PM'),
        :end => DateTime.parse('3rd Feb 2001 10:06 PM'),
        :title => "the_duck_walked_up and reduced an equation to smolders",
        :color => "#fff",
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => '',
        :description => "roger zurawicki farts alot"
    )
    output1 = toke.tokenize(event1, all_features)
    expected1 = ["the", "duck", "walk", "up", "and", "reduce", "an", "equation", "to", "smolder", "roger",
                 "zurawicki", "fart", "alot", "start_time 16", "end_time 22", "weekday SAT"]
    assert_equal [], (output1 - expected1)

    event2 = Event.new(
        :allDay => false,
        :start => DateTime.parse('4rd Feb 2001 12:06 PM'),
        :end => DateTime.parse('3rd Feb 2001 6:06 PM'),
        :title => "ALL CAPS: A PERFORMANCE; BY GREG MORRISETT",
        :color => "#fff",
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => '',
        :description => "thou, shalt, not, write, style, grade, zero, code?!"
    )
    output2 = toke.tokenize(event2, all_features)
    expected2 = ["all", "cap", "a", "perform", "by", "greg", "morrisett", "start_time 12", "end_time 18", "thou",
                 "shalt", "not", "write", "style", "grade", "zero", "code", "weekday SUN"]
    assert_equal [], (output2 - expected2)

    event3 = Event.new(
        :allDay => false,
        :start => DateTime.parse('3rd Feb 2001 12:06 AM'),
        :end => DateTime.parse('3rd Feb 2001 3:57 PM'),
        :title => "cheesecake bayes multi James",
        :color => "#fff",
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => 'burger shop',
        :description => ''
    )
    output3 = toke.tokenize(event3, all_features)
    expected3 = ["location burger shop", "start_time 0", "end_time 15", "cheesecake", "Bayes", "multi",
                 "james", "weekday SAT"]
    assert_equal [], (output3 - expected3)
  end
end