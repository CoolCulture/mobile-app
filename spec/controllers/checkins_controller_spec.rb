require 'spec_helper'

describe CheckinsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user, admin: true)
    sign_in user
  end
  
  describe "checkin" do
    let(:family_card) { FactoryGirl.create(:family_card) }
    let(:museum) { FactoryGirl.create(:museum) }

    describe "GET show" do
      it "should return success" do
        checkin = FactoryGirl.create(:checkin, { date: Date.today })
        get :show, id: checkin.slug, format: :json
        response.should be_ok
        resp = JSON.parse(response.body)
        resp['lastName'].should == checkin.last_name
      end
    end
  end
end
