require 'spec_helper'

describe Checkin do
  it { should belong_to(:museum) }
  it { should belong_to(:family_card) }

  it {should validate_presence_of(:number_of_children)}
  it {should validate_presence_of(:number_of_adults)}
  it {should validate_presence_of(:date)}

  describe "checkin limit" do
    it "should validate that only one checkin per museum and family card happen a day" do
      first_checkin = FactoryGirl.create(:checkin)

      second_checkin = FactoryGirl.build(:checkin, { museum: first_checkin.museum })
      second_checkin.save

      second_checkin.errors.first.last.should == "You can only Check into the museum once per day"
    end
  end

end
