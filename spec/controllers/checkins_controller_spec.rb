require 'rails_helper'

describe CheckinsController do
  before(:each) do
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
        expect(response).to be_ok
        resp = JSON.parse(response.body)
        expect(resp['lastName']).to eq(checkin.last_name)
      end
    end
  end
end
