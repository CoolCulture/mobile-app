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
      no_prior_activities = recurring_activity.generate_upcoming_events.count

      one_time_activity = FactoryGirl.create(:one_time_activity,
                                              date: Date.today.next_day(2),
                                              recurring_activity_id: recurring_activity.id)

      prior_activities = recurring_activity.generate_upcoming_events.count

      expect(no_prior_activities - prior_activities).to eq 1
    end
  end
end