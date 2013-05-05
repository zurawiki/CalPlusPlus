require 'stuff-classifier'
require 'test_helper'
=begin
class TestNaiveBayesClassification < TestBase
  before do
    set_classifier StuffClassifier::Bayes.new 'Importance'
    meet_sadik = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'meet Sadik',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    buy_drink = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'buy drink',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    lunch_with_kevin = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'lunch with Kevin',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    go_walk = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'go walk',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    do_math_homework = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'do_math_homework',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    browse_facebook = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'browse facebook',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )

    train :important, meet_sadik
    train :not, buy_drink
    train :important, lunch_with_kevin
    train :not, go_walk
    train :important, do_math_homework
    train :not, browse_facebook
  end

  def test_important
    meet_chad = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'meet Chad',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    dinner_with_dev = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'dinner with Dev',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    physics_homework = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'physics homework',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    should_be :important, meet_chad
    should_be :important, dinner_with_dev
    should_be :important, physics_homework
  end

  def test_not_important
    look_at_facebook = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'look at facebook',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    go_browse_drinks = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'go browse drinks',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    should_be :not, look_at_facebook
    should_be :not, go_browse_drinks
  end

  def test_ambiguous
    # TODO
    class_ = Event.new(
        :allDay => false,
        :start => Date.parse('3rd Feb 2001 04:05:06 PM'),
        :end => Date.parse('3rd Feb 2001 04:10:06 PM'),
        :title => 'class',
        :color => '#fff',
        :importance => 0,
        :autoImportance => true,
        :user_id => 42,
        :location => ''
    )
    should_be :important, class_
  end

end

=end
