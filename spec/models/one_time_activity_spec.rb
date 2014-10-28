require 'rails_helper'

describe OneTimeActivity do
  describe "upcoming scope" do
    it "should return all events in the next week" do
      museum = FactoryGirl.create(:museum)
      upcoming_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,4), museum: museum)
      old_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,3), museum: museum)
      future_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,11), museum: museum)

      day = Date.new(2014,11,4)
      upcoming = OneTimeActivity.upcoming(day, day + 6.days)
      expect(upcoming).to eq([upcoming_activity])
    end

    it "should return the events in sorted order" do
      museum = FactoryGirl.create(:museum)
      upcoming_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,4), museum: museum)
      upcoming_activity2 = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,5), museum: museum)

      day = Date.new(2014,11,4)
      upcoming = OneTimeActivity.upcoming(day, day + 6.days)
      expect(upcoming).to eq([upcoming_activity, upcoming_activity2])
    end
  end

end
