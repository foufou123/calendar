require 'spec_helper'

describe Event do
  it { should belong_to :user }

  describe "this_week" do
    it "returns true if an event's start date and end date are during the current week" do
    test_event = Event.create({:description => 'Meeting', :location => '123 Jump St.', :start_date => '2014-03-27', :end_date => '2014-03-27'})
    test_event.this_week.should eq true
    end
  end
end
