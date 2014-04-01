require 'spec_helper'

describe CheckinController do
  describe "checkin" do
    context "with valid family card id and last name" do
      it "creates new checkin" do
        family_card = FactoryGirl.create(:family_card)
        museum = FactoryGirl.create(:museum)

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

    # context "with existing family card id and invalid last name" do
    #   it "does not create a new checkin" do
    #     family_card = FactoryGirl.create(:family_card)
    #     museum = FactoryGirl.create(:museum)

    #     expect{
    #         post :create,
    #           museum_id: museum.name_id,
    #           family_card_id: family_card.pass_id,
    #           last_name: "Invalid",
    #           checkin: {
    #             number_of_children: 3,
    #             number_of_adults: 2
    #           },
    #           format: :json
    #     }.to_not change(Checkin, :count).by(1)
    #   end
    # end

  end
end
