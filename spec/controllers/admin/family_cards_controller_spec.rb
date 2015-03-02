require 'spec_helper'
include ActionDispatch::TestProcess

describe Admin::FamilyCardsController do
  before(:each) do
    user = FactoryGirl.create(:user)
    user.update_attributes(admin: true)
    sign_in user
  end

  describe "GET index" do
    it "assigns @family_cards" do
      family_card = FactoryGirl.create(:family_card)
      get :index
      expect(assigns(:family_cards)).to eq([family_card])
    end

    it "assigns @family_cards with the searched for name" do
      other_family_card = FactoryGirl.create(:family_card)
      joe_family_card = FactoryGirl.create(:family_card, id: 20000, 
                                                         pass_id: 20000,
                                                         first_name: "Joe")
      
      get :index, search: "Joe"
      expect(assigns(:family_cards)).to eq([joe_family_card])
    end

    it "assigns @family_cards with the searched for id" do
      other_family_card = FactoryGirl.create(:family_card)
      joe_family_card = FactoryGirl.create(:family_card, id: 20000, 
                                                         pass_id: 20000,
                                                         first_name: "Joe")
      
      get :index, search: "20000"
      expect(assigns(:family_cards)).to eq([joe_family_card])
    end
  end

  describe "import" do
    it "should import CSV and create family cards" do
      csv_to_import = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'family_cards.csv'), "text/csv")
      post :import, file: csv_to_import

      expect(flash[:notice]).to eq("Family Cards imported successfully.")
      expect(FamilyCard.count).to eq(3)
      expect(assigns(:warnings)).to be_nil
    end

    it "should report errors in the csv when there are any" do
      csv_to_import = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'family_cards_with_errors.csv'), "text/csv")

      post :import, file: csv_to_import

      expect(flash[:notice]).to eq("Family Cards imported successfully.")
      expect(FamilyCard.count).to eq(1)
      expect(assigns(:warnings).count).to eq 1
    end
  end
end
