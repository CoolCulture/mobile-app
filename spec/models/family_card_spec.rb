require 'spec_helper'

describe FamilyCard do
  it {should validate_presence_of(:last_name)}
  it {should validate_presence_of(:pass_id)}

  it {should validate_uniqueness_of(:pass_id)}

  describe "valid_last_name" do
    it "should return true if last name matches family card" do
      family_card = FactoryGirl.build(:family_card)

      valid = family_card.valid_last_name("Cooling")
      valid.should == true
    end

    it "should return false if last name does not match family card" do
      family_card = FactoryGirl.build(:family_card)

      valid = family_card.valid_last_name("Cooly")
      valid.should == false
    end
  end
end
