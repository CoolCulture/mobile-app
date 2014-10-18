require 'spec_helper'

describe FamilyCardsController do

  include AuthHelper
  before(:each) do
    http_login
  end

  describe "GET index" do
    it "assigns @family_cards" do
      family_card = FactoryGirl.create(:family_card)
      get :index
      expect(assigns(:family_cards)).to eq([family_card])
    end
  end

  describe "import" do
    it "should import CSV and create family cards" do
      csv_to_import = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'family_cards.csv'), "text/csv")
      post :import, file: csv_to_import

      flash[:notice].should eq("Family Cards imported successfully.")
      FamilyCard.count.should == 2
    end
  end

end
