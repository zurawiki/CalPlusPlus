require 'test_helper'
require 'lib/stuff-classifier/tokenizer'

class TestTokenizer < TestBase
  def test_tokenize_event
     toke = StuffClassifier::Tokenizer.new
     new_event = Event.new(
         :allDay => false,
         :start => DateTime.parse('3rd Feb 2001 04:06 PM'),
         :end => DateTime.parse('3rd Feb 2001 10:06 PM'),
         :title => "the duck walked up and reduced an equation to smolders",
         :color => "#fff",
         :importance => 0,
         :autoImportance => true,
         :user_id => 42,
         :location => 'cheesecake factory',
         :description => "roger zurawicki farts alot"
     )
    puts toke.tokenize(new_event, [:title, :description, :start_time, :end_time, :weekday, :location])
    assert(true)
  end
end