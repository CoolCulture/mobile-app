require 'spec_helper'
include ActionDispatch::TestProcess

describe Admin::RecurringActivitiesController do
  before(:each) do
    user = FactoryGirl.create(:user)
    user.update_attributes(admin: true)
    sign_in user
  end

  describe "POST #create" do
    it "creates a new recurring activity" do
      museum = FactoryGirl.create(:museum)
      expect {
        post :create, museum_id: museum.id, recurring_activity: FactoryGirl.attributes_for(:recurring_activity)
      }.to change(RecurringActivity, :count).by(1)
    end

    it "creates associated one time activities on create" do
      museum = FactoryGirl.create(:museum)
      expect {
        post :create, museum_id: museum.id, recurring_activity: FactoryGirl.attributes_for(:recurring_activity)
      }.to change(OneTimeActivity, :count).by(4)
    end
  end
end