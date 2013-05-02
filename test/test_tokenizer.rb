require 'test_helper'
require 'lib/stuff-classifier/tokenizer'

class TestTokenizer < TestBase
  def test_tokenize_event
     toke = Tokenizer.new
     new_event = Event.create(
         :allDay => false,
         :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
         :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
         :title => "the duck walked up and reduced an equation to smolders",
         :color => "#fff",
         :importance => 0,
         :autoImportance => true,
         :user_id => 42,
         :location => ""
     )
    puts toke.tokenize(new_event)
    assert(true)
  end
end