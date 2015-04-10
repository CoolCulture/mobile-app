require 'rails_helper'

describe RecurringActivity do
  describe "default scope" do
    it "should only return active activities" do
      FactoryGirl.create(:recurring_activity)
      FactoryGirl.create(:recurring_activity, active: false)

      activities = RecurringActivity.count
      expect(activities).to eq 1
    end
  end

  describe "#generate_upcoming_events" do
    it "should return an array of OneTimeActivity ready hashes" do
      recurring_activity = FactoryGirl.create(:recurring_activity)
      one_time_activities = recurring_activity.generate_upcoming_events

      expect(one_time_activities).not_to be_empty
      expect(one_time_activities.first).to include(:name, :description, :date)
    end

    it "should not duplicate already created one time activities" do
      recurring_activity = FactoryGirl.create(:recurring_activity)
      recurring_activity.generate_upcoming_events.each { |attrs| OneTimeActivity.create(attrs) }
      
      activities_count = recurring_activity.generate_upcoming_events.count
      
      expect {
        recurring_activity.generate_upcoming_events.each { |attrs| OneTimeActivity.create(attrs) }
      }.to change(OneTimeActivity,:count).by(0)
    end
  end
end