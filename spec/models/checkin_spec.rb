require 'rails_helper'

describe Checkin do
  describe "checkin limit" do
    it "should validate that only one checkin per museum and family card happen a day" do
      first_checkin = FactoryGirl.create(:checkin)

      second_checkin = FactoryGirl.build(:checkin, { museum: first_checkin.museum })
      second_checkin.save

      expect(second_checkin.errors.first.last).to eq("You can only Check into the museum once per day")
    end
  end

end
