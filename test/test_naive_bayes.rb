require 'stuff-classifier'
require 'test_helper'

class TestNaiveBayesClassification < TestBase

  before do
    @test_data = [{:title => '[ APMTH 21a ] First Official Section and Homework 1', :importance => 1, :allDay => false, :start => '2013-01-14 20:00:00', :end => '2013-01-14 21:00:00'}, {:title => '7 pm Rehearsal - LLH', :importance => 1, :allDay => false, :start => '2012-09-20 22:45:00', :end => '2012-09-21 01:30:00'}, {:title => 'Advising at the College', :importance => 1, :allDay => false, :start => '2012-04-22 18:00:00', :end => '2012-04-22 19:00:00'}, {:title => 'allyDVM meeting', :importance => 1, :allDay => false, :start => '2012-05-08 18:30:00', :end => '2012-05-08 19:30:00'}, {:title => 'Alt blocks meet today', :importance => 1, :allDay => true, :start => '2011-10-22 00:00:00', :end => '2011-10-22 00:00:00'}, {:title => 'APPLE COMPUTER PICK-UP', :importance => 1, :allDay => false, :start => '2010-08-26 13:00:00', :end => '2010-08-26 22:00:00'}, {:title => 'Babysit Mahika?', :importance => 1, :allDay => false, :start => '2011-10-26 23:00:00', :end => '2011-10-27 00:00:00'}, {:title => 'Babysitting Plutes', :importance => 1, :allDay => false, :start => '2012-08-03 17:00:00', :end => '2012-08-03 22:00:00'}, {:title => 'Babysitting Pluts', :importance => 1, :allDay => false, :start => '2012-06-14 18:00:00', :end => '2012-06-14 20:30:00'}, {:title => 'BALLROOM dancing', :importance => 1, :allDay => false, :start => '2012-09-12 02:00:00', :end => '2012-09-12 03:30:00'}, {:title => 'Birthday :D', :importance => 1, :allDay => true, :start => '2058-12-18 00:00:00', :end => '2058-12-18 00:00:00'}, {:title => "Cesar's Office Hours", :importance => 1, :allDay => false, :start => '2010-02-23 18:30:00', :end => '2010-02-23 21:30:00'}, {:title => 'Christmas', :importance => 1, :allDay => true, :start => '2013-12-25 00:00:00', :end => '2013-12-25 00:00:00'}, {:title => 'Collect Rec Letters- ND', :importance => 1, :allDay => false, :start => '2011-02-05 00:00:00', :end => '2011-02-05 01:00:00'}, {:title => 'College visit for Lehigh University', :importance => 1, :allDay => false, :start => '2011-10-14 18:30:00', :end => '2011-10-14 19:30:00'}, {:title => 'Cultural: Feast', :importance => 1, :allDay => true, :start => '2009-11-13 00:00:00', :end => '2009-11-13 00:00:00'}, {:title => " David's Office Hours", :importance => 1, :allDay => false, :start => '2009-04-24 18:00:00', :end => '2009-04-24 20:00:00'}, {:title => 'Day Biking Trip to Moray and Salineras', :importance => 1, :allDay => true, :start => '2011-09-25 00:00:00', :end => '2011-09-25 00:00:00'}, {:title => 'Daylight Saving Time Begins', :importance => 1, :allDay => true, :start => '2012-03-11 00:00:00', :end => '2012-03-11 00:00:00'}, {:title => 'Daylight Saving Time Ends', :importance => 1, :allDay => true, :start => '2012-11-04 00:00:00', :end => '2012-11-04 00:00:00'}, {:title => " Diana's Office Hours", :importance => 1, :allDay => false, :start => '2009-03-25 13:00:00', :end => '2009-03-25 15:00:00'}, {:title => " Diana's OH's", :importance => 1, :allDay => false, :start => '2008-10-28 17:00:00', :end => '2008-10-28 21:00:00'}, {:title => 'Election Day', :importance => 1, :allDay => true, :start => '2013-11-05 00:00:00', :end => '2013-11-05 00:00:00'}, {:title => 'Epic Interview', :importance => 1, :allDay => false, :start => '2012-11-09 19:00:00', :end => '2012-11-09 19:30:00'}, {:title => 'Expense Report', :importance => 1, :allDay => true, :start => '2016-05-28 00:00:00', :end => '2016-05-28 00:00:00'}, {:title => 'Expos', :importance => 1, :allDay => false, :start => '2012-10-02 15:00:00', :end => '2012-10-02 16:00:00'}, {:title => 'EXPOS SECTION CLOSES AT 11:59', :importance => 1, :allDay => false, :start => '2010-09-06 03:30:00', :end => '2010-09-06 04:00:00'}, {:title => 'Facebook Speaker', :importance => 1, :allDay => false, :start => '2012-11-27 21:00:00', :end => '2012-11-27 22:00:00'}, {:title => 'Fencing, MAC 3rd Floor', :importance => 1, :allDay => false, :start => '2014-12-04 01:00:00', :end => '2014-12-04 02:00:00'}, {:title => 'Final Examinations', :importance => 1, :allDay => true, :start => '2010-12-13 00:00:00', :end => '2010-12-21 00:00:00'}, {:title => 'FIRST DAY OF CLASSES!', :importance => 1, :allDay => false, :start => '2012-09-04 12:00:00', :end => '2012-09-04 13:00:00'}, {:title => 'Fitness', :importance => 1, :allDay => false, :start => '2012-08-17 15:00:00', :end => '2012-08-17 16:00:00'}, {:title => 'Forest Foundation Internship Orientation', :importance => 1, :allDay => true, :start => '2012-06-04 00:00:00', :end => '2012-06-04 00:00:00'}, {:title => 'General Body Meeting', :importance => 1, :allDay => false, :start => '2015-02-27 02:30:00', :end => '2015-02-27 03:30:00'}, {:title => 'Graduation', :importance => 1, :allDay => true, :start => '2012-06-07 00:00:00', :end => '2012-06-07 00:00:00'}, {:title => 'HCS Systems Meeting', :importance => 1, :allDay => false, :start => '2010-10-19 01:00:00', :end => '2010-10-19 02:00:00'}, {:title => 'Huddle with Mihir', :importance => 1, :allDay => false, :start => '2012-11-12 21:30:00', :end => '2012-11-12 22:00:00'}, {:title => 'Land Practice', :importance => 1, :allDay => false, :start => '2010-01-31 14:00:00', :end => '2010-01-31 16:00:00'}, {:title => 'Language & Music Placement Tests', :importance => 1, :allDay => false, :start => '2009-08-28 12:00:00', :end => '2009-08-28 16:00:00'}, {:title => 'LS1A Office Hours BioLabs 1081 (16 Divinity Avenue)', :importance => 1, :allDay => false, :start => '2012-09-04 21:30:00', :end => '2012-09-04 23:00:00'}, {:title => 'Lunch with Josh Friedman', :importance => 1, :allDay => false, :start => '2009-04-27 16:00:00', :end => '2009-04-27 17:00:00'}, {:title => 'Master Class (Zazofsky)', :importance => 1, :allDay => false, :start => '2012-08-09 19:00:00', :end => '2012-08-09 20:00:00'}, {:title => 'meet Erica', :importance => 1, :allDay => true, :start => '2012-11-10 00:00:00', :end => '2012-11-10 00:00:00'}, {:title => 'Meet the Deans', :importance => 1, :allDay => false, :start => '2012-08-30 15:00:00', :end => '2012-08-30 17:00:00'}, {:title => 'MIT Interview', :importance => 1, :allDay => false, :start => '2011-10-21 19:30:00', :end => '2011-10-21 20:30:00'}, {:title => " Mother's Day", :importance => 1, :allDay => true, :start => '2013-05-12 00:00:00', :end => '2013-05-12 00:00:00'}, {:title => 'NESBA Billerica', :importance => 1, :allDay => false, :start => '2012-10-13 16:00:00', :end => '2012-10-14 02:00:00'}, {:title => " New Year's Day", :importance => 1, :allDay => true, :start => '2011-01-01 00:00:00', :end => '2011-01-01 00:00:00'}, {:title => 'NYA Essay Tutoring', :importance => 1, :allDay => false, :start => '2011-08-03 01:00:00', :end => '2011-08-03 03:00:00'}, {:title => 'Office Hours', :importance => 1, :allDay => false, :start => '2010-02-03 01:00:00', :end => '2010-02-03 03:00:00'}, {:title => 'ONLINE REGISTRATION BEGINS', :importance => 1, :allDay => true, :start => '2010-08-26 00:00:00', :end => '2010-08-26 00:00:00'}, {:title => 'Period 2: Upload a Code Review Document', :importance => 1, :allDay => false, :start => '2012-02-28 23:00:00', :end => '2012-02-28 23:00:00'}, {:title => 'Petition Deadline - April Class', :importance => 1, :allDay => true, :start => '2009-03-27 00:00:00', :end => '2009-03-27 00:00:00'}, {:title => 'PICK UP LUNCH!', :importance => 1, :allDay => false, :start => '2012-09-18 15:00:00', :end => '2012-09-18 15:30:00'}, {:title => 'Preliminary Auditions (3 hrs per day)', :importance => 1, :allDay => true, :start => '2007-09-22 00:00:00', :end => '2007-09-24 00:00:00'}, {:title => 'Red Sox (1) @ Athletics (6)', :importance => 1, :allDay => false, :start => '2012-07-03 02:05:00', :end => '2012-07-03 05:05:00'}, {:title => 'Red Sox (1) @ Indians (3)', :importance => 1, :allDay => false, :start => '2011-04-05 23:05:00', :end => '2011-04-06 02:05:00'}, {:title => 'Refreshments for Grandparents', :importance => 1, :allDay => false, :start => '2011-11-02 10:45:00', :end => '2011-11-02 14:00:00'}, {:title => 'Rehearsal', :importance => 1, :allDay => false, :start => '2008-02-09 21:30:00', :end => '2008-02-10 00:00:00'}, {:title => 'rehearsal, NCT', :importance => 1, :allDay => false, :start => '2008-09-08 22:00:00', :end => '2008-09-09 00:30:00'}, {:title => 'Required entryway meeting', :importance => 1, :allDay => false, :start => '2012-08-29 01:00:00', :end => '2012-08-29 03:00:00'}, {:title => 'Required: Extended Orientation Part 1', :importance => 1, :allDay => false, :start => '2012-09-03 18:40:00', :end => '2012-09-03 20:00:00'}, {:title => 'SAT IIs - Math 1 & English Literature', :importance => 1, :allDay => false, :start => '2010-12-04 11:00:00', :end => '2010-12-04 18:30:00'}, {:title => 'Scheduled call with Tinkuy', :importance => 1, :allDay => true, :start => '2011-09-11 00:00:00', :end => '2011-09-11 00:00:00'}, {:title => 'SHAPE Meeting', :importance => 1, :allDay => false, :start => '2013-11-20 01:00:00', :end => '2013-11-20 02:00:00'}, {:title => 'Skype with Lizzy', :importance => 1, :allDay => true, :start => '2012-01-28 00:00:00', :end => '2012-01-28 00:00:00'}, {:title => 'Student/Parent Fundraiser Kickoff!!', :importance => 1, :allDay => false, :start => '2012-09-26 23:00:00', :end => '2012-09-27 00:00:00'}, {:title => 'Swim Practice', :importance => 1, :allDay => false, :start => '2010-01-14 10:00:00', :end => '2010-01-14 12:00:00'}, {:title => 'Tutor Alex', :importance => 1, :allDay => false, :start => '2011-04-21 04:00:00', :end => '2011-04-21 05:00:00'}, {:title => 'Tutoring Danielle', :importance => 1, :allDay => false, :start => '2012-08-09 22:30:00', :end => '2012-08-09 23:30:00'}, {:title => 'Tutoring Juliana', :importance => 1, :allDay => false, :start => '2012-07-24 18:00:00', :end => '2012-07-24 19:00:00'}, {:title => 'Warren v. Brown debate', :importance => 1, :allDay => false, :start => '2012-10-10 23:00:00', :end => '2012-10-11 00:00:00'}, {:title => 'Yankees (3) @ Red Sox (2)', :importance => 1, :allDay => false, :start => '2011-08-05 23:10:00', :end => '2011-08-06 02:10:00'}, {:title => 'Zynga tech talk', :importance => 1, :allDay => false, :start => '2011-10-19 23:00:00', :end => '2011-10-20 00:00:00'}, {:title => '18.02 Calc', :importance => 0, :allDay => false, :start => '2012-11-01 17:00:00', :end => '2012-11-01 18:00:00'}, {:title => '7.012 Bio', :importance => 0, :allDay => false, :start => '2012-11-05 15:00:00', :end => '2012-11-05 16:00:00'}, {:title => 'Am 21a', :importance => 0, :allDay => false, :start => '2012-10-15 15:00:00', :end => '2012-10-15 16:00:00'}, {:title => 'Band Open Rehearsal', :importance => 0, :allDay => false, :start => '2012-09-06 20:00:00', :end => '2012-09-06 22:00:00'}, {:title => 'Columbus Day', :importance => 0, :allDay => true, :start => '2011-10-10 00:00:00', :end => '2011-10-10 00:00:00'}, {:title => 'Columbus Day - SR Office closed', :importance => 0, :allDay => true, :start => '2008-10-13 00:00:00', :end => '2008-10-13 00:00:00'}, {:title => 'CS50', :importance => 0, :allDay => false, :start => '2014-03-26 17:00:00', :end => '2014-03-26 18:30:00'}, {:title => 'Cultural: Mooncake Study Break', :importance => 0, :allDay => true, :start => '2009-09-03 00:00:00', :end => '2009-09-03 00:00:00'}, {:title => 'Ec 10', :importance => 0, :allDay => false, :start => '2012-12-05 17:00:00', :end => '2012-12-05 18:00:00'}, {:title => 'ER 18', :importance => 0, :allDay => false, :start => '2013-05-27 14:00:00', :end => '2013-05-27 15:00:00'}, {:title => 'EVENING SOCIAL EVENTS.', :importance => 0, :allDay => false, :start => '2010-09-02 01:00:00', :end => '2010-09-02 04:00:00'}, {:title => 'Flag Day', :importance => 0, :allDay => true, :start => '2011-06-14 00:00:00', :end => '2011-06-14 00:00:00'}, {:title => 'Full moon 2:58pm', :importance => 0, :allDay => true, :start => '2011-08-13 00:00:00', :end => '2011-08-13 00:00:00'}, {:title => 'Full moon 4:13pm', :importance => 0, :allDay => true, :start => '2011-06-15 00:00:00', :end => '2011-06-15 00:00:00'}, {:title => 'Full moon 5:27am', :importance => 0, :allDay => true, :start => '2011-09-12 00:00:00', :end => '2011-09-12 00:00:00'}, {:title => 'Going Home!', :importance => 0, :allDay => false, :start => '2012-12-17 05:00:00', :end => '2012-12-17 05:00:00'}, {:title => 'Haircut', :importance => 0, :allDay => false, :start => '2012-08-14 20:00:00', :end => '2012-08-14 21:00:00'}, {:title => 'History of Blues', :importance => 0, :allDay => false, :start => '2013-12-30 18:30:00', :end => '2013-12-30 19:45:00'}, {:title => 'Katie Hang out', :importance => 0, :allDay => false, :start => '2012-12-13 02:00:00', :end => '2012-12-13 04:00:00'}, {:title => 'Last quarter 9:39am', :importance => 0, :allDay => true, :start => '2011-09-20 00:00:00', :end => '2011-09-20 00:00:00'}, {:title => 'Life Sciences 1a', :importance => 0, :allDay => false, :start => '2011-10-06 17:00:00', :end => '2011-10-06 18:30:00'}, {:title => 'LMAO: A Night of Comedy', :importance => 0, :allDay => false, :start => '2010-09-04 01:00:00', :end => '2010-09-04 02:00:00'}, {:title => 'Long Weekend', :importance => 0, :allDay => true, :start => '2011-10-09 00:00:00', :end => '2011-10-09 00:00:00'}, {:title => 'LPS A', :importance => 0, :allDay => false, :start => '2011-09-23 13:00:00', :end => '2011-09-23 14:00:00'}, {:title => 'LS1A', :importance => 0, :allDay => false, :start => '2012-10-30 17:00:00', :end => '2012-10-30 18:30:00'}, {:title => 'Magic', :importance => 0, :allDay => false, :start => '2012-02-02 02:00:00', :end => '2012-02-02 04:00:00'}, {:title => 'Math 21a', :importance => 0, :allDay => false, :start => '2012-09-14 14:00:00', :end => '2012-09-14 15:00:00'}, {:title => 'Math 23a Lecture', :importance => 0, :allDay => false, :start => '2012-09-14 15:00:00', :end => '2012-09-14 16:00:00'}, {:title => 'Math Team', :importance => 0, :allDay => false, :start => '2012-02-28 19:40:00', :end => '2012-02-28 20:10:00'}, {:title => 'Modern India and South Asia', :importance => 0, :allDay => false, :start => '2012-09-17 14:00:00', :end => '2012-09-17 15:00:00'}, {:title => 'No Classes (University Holiday)', :importance => 0, :allDay => true, :start => '2012-11-23 00:00:00', :end => '2012-11-23 00:00:00'}, {:title => 'Note: There will be no classes today.', :importance => 0, :allDay => true, :start => '2011-11-05 00:00:00', :end => '2011-11-05 00:00:00'}, {:title => 'Patriot Day', :importance => 0, :allDay => true, :start => '2013-09-11 00:00:00', :end => '2013-09-11 00:00:00'}, {:title => 'Poetry Slam', :importance => 0, :allDay => false, :start => '2012-04-23 02:00:00', :end => '2012-04-23 05:00:00'}, {:title => 'Practice', :importance => 0, :allDay => false, :start => '2012-08-08 17:30:00', :end => '2012-08-08 18:30:00'}, {:title => 'Presidents Day', :importance => 0, :allDay => true, :start => '2012-02-20 00:00:00', :end => '2012-02-20 00:00:00'}, {:title => 'Reading Period', :importance => 0, :allDay => true, :start => '2009-12-04 00:00:00', :end => '2009-12-11 00:00:00'}, {:title => 'Reception for parents and faculty', :importance => 0, :allDay => false, :start => '2009-10-31 11:30:00', :end => '2009-10-31 15:00:00'}, {:title => 'Sib Party', :importance => 0, :allDay => true, :start => '2010-09-17 00:00:00', :end => '2010-09-17 00:00:00'}, {:title => 'Smart Women Securities', :importance => 0, :allDay => false, :start => '2012-09-19 23:30:00', :end => '2012-09-20 01:00:00'}, {:title => 'SOC-WORLD 25', :importance => 0, :allDay => false, :start => '2012-09-06 14:00:00', :end => '2012-09-06 15:30:00'}, {:title => 'SOCIAL: Icebreaker', :importance => 0, :allDay => false, :start => '2013-01-23 15:00:00', :end => '2013-01-23 15:30:00'}, {:title => 'Spring Break from PEA', :importance => 0, :allDay => true, :start => '2011-03-19 00:00:00', :end => '2011-03-19 00:00:00'}, {:title => " St. Patrick's Day ", :importance => 0, :allDay => true, :start => '2012-03-17 00:00:00', :end => '2012-03-17 00:00:00'}, {:title => 'Statistics', :importance => 0, :allDay => false, :start => '2012-05-01 14:00:00', :end => '2012-05-01 14:20:00'}, {:title => 'STUDENT COMPUTING @ HARVARD', :importance => 0, :allDay => false, :start => '2010-08-26 16:00:00', :end => '2010-08-26 16:30:00'}, {:title => 'Tea', :importance => 0, :allDay => false, :start => '2006-05-03 00:30:00', :end => '2006-05-03 01:00:00'}, {:title => 'The Gen Ed Difference:Linking the Liberal Arts to Life', :importance => 0, :allDay => false, :start => '2009-09-03 20:30:00', :end => '2009-09-03 22:00:00'}, {:title => 'undergrad research journal', :importance => 0, :allDay => false, :start => '2012-09-08 20:00:00', :end => '2012-09-08 21:00:00'}, {:title => 'WELLESLEY COLLEGE SPEAKER: Alan Schecter', :importance => 0, :allDay => false, :start => '2007-04-26 21:00:00', :end => '2007-04-27 02:30:00'}, {:title => 'Winter Break', :importance => 0, :allDay => true, :start => '2009-12-22 00:00:00', :end => '2010-01-24 00:00:00'}, {:title => 'Working on Movie', :importance => 1, :allDay => false, :start => '2012-06-14 21:00:00', :end => '2012-06-14 23:30:00'}, {:title => " Yasi's Birthday ", :importance => 1, :allDay => true, :start => '2047-07-30 00:00:00', :end => '2047-07-30 00:00:00'}]

    @storage_path = Rails.root.join('tmp').join('test').join('test_naive_bayes.db')
    @storage = StuffClassifier::FileStorage.new(@storage_path)

    set_classifier StuffClassifier::Bayes.new 'Importance', {:storage => @storage}

    if @classifier.total_categories == 0

      @test_data.each do |item|
        event = Event.new(
            :allDay => item[:allDay],
            :start => Date.parse(item[:start]),
            :end => Date.parse(item[:end]),
            :title => item[:title],
            :color => '#fff',
            :importance => item[:importance],
            :autoImportance => false,
            :user_id => 42,
            :location => ''
        )
        if event[:importance] == 1 then
          train :important, event
        else
          train :not, event
        end
      end

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

      @classifier.save_state
    end
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

