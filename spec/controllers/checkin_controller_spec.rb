require 'spec_helper'

describe CheckinController do
  describe "checkin" do
    let(:family_card) { FactoryGirl.create(:family_card) }
    let(:museum) { FactoryGirl.create(:museum) }

    context "with valid family card id and last name" do
      it "creates new checkin" do
        expect{
            post :create,
              museum_id: museum.name_id,
              family_card_id: family_card.pass_id,
              last_name: family_card.last_name,
              checkin: {
                number_of_children: 3,
                number_of_adults: 2
              },
              format: :json
        }.to change(Checkin, :count).by(1)
      end
    end

    context "with existing family card id and invalid last name" do
      it "does not create a new checkin" do
        expect{
            post :create,
              museum_id: museum.name_id,
              family_card_id: family_card.pass_id,
              last_name: "Invalid",
              checkin: {
                number_of_children: 3,
                number_of_adults: 2
              },
              format: :json
        }.to_not change(Checkin, :count).by(1)
      end

      context "with invalid family_card id" do
        it "does not create a new checkin" do
          expect{
              post :create,
                museum_id: museum.name_id,
                family_card_id: 39494,
                last_name: family_card.last_name,
                checkin: {
                  number_of_children: 3,
                  number_of_adults: 2
                },
                format: :json
          }.to_not change(Checkin, :count).by(1)
        end
      end

      context "when a checkin on the same day and museum already exists" do
        it "does not create second checkin" do
          expect{
            post :create,
              museum_id: museum.name_id,
              family_card_id: family_card.pass_id,
              last_name: family_card.last_name,
              checkin: {
                number_of_children: 3,
                number_of_adults: 2
              },
              format: :json
          }.to change(Checkin, :count).by(1)

          expect{
            post :create,
              museum_id: museum.name_id,
              family_card_id: family_card.pass_id,
              last_name: family_card.last_name,
              checkin: {
                number_of_children: 3,
                number_of_adults: 2
              },
              format: :json
          }.to_not change(Checkin, :count).by(1)
        end
      end
    end

    describe "GET show" do
      it "should return success" do
        checkin = FactoryGirl.create(:checkin, { date: Date.today })
        get :show, museum_name_id: checkin.museum.name_id, family_card_id: checkin.family_card_id
        response.should be_ok
        response.body.should == checkin.to_json
      end
    end
  end
end
