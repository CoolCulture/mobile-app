require 'rails_helper'

describe CheckinsController do
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
        }.to change(Checkin, :count).by(0)
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
          }.to change(Checkin, :count).by(0)
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
          }.to change(Checkin, :count).by(0)
        end
      end
    end

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
