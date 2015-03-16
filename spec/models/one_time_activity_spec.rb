require 'rails_helper'

describe OneTimeActivity do
  describe "default scope" do
    it "should only return active activities" do
      FactoryGirl.create(:one_time_activity)
      FactoryGirl.create(:one_time_activity, active: false)

      activities = OneTimeActivity.count
      expect(activities).to eq 1
    end
  end

  describe "old scope" do
    it "should return events that passed more than three days ago" do
      museum = FactoryGirl.create(:museum)
      not_old_enough_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,3), museum: museum)
      old_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,10,30), museum: museum)
      future_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,11), museum: museum)

      day = Date.new(2014,11,4)
      old_activities = OneTimeActivity.old(day)
      expect(old_activities).to eq([old_activity])
    end
  end

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

  describe ".deactivate_old_activities" do
    it "should deactivate old activities" do
      museum = FactoryGirl.create(:museum)
      old_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,10,30), museum: museum)
      new_activity = FactoryGirl.create(:one_time_activity, date: Date.new(2014,11,30), museum: museum)
      day = Date.new(2014,11,4)

      deactivated_activities = OneTimeActivity.deactivate_old_activities(day)
      activities = OneTimeActivity.count
      
      expect(activities).to eq 1
      expect(deactivated_activities).to eq([old_activity])
    end
  end
end