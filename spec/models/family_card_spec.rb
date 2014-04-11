require 'spec_helper'

describe FamilyCard do
  it {should validate_presence_of(:last_name)}
  it {should validate_presence_of(:pass_id)}

  it {should validate_uniqueness_of(:pass_id)}

  describe "valid_last_name" do
    context "matches family card last name" do
      it "should return true" do
        family_card = FactoryGirl.build(:family_card)

        valid = family_card.valid_last_name("Cooling")
        valid.should == true
      end

      it "should return true for case-insensitive" do
        family_card = FactoryGirl.build(:family_card)

        valid = family_card.valid_last_name("cooling")
        valid.should == true
      end
    end

    context "does not match family card last name" do
      it "should return false" do
        family_card = FactoryGirl.build(:family_card)

        valid = family_card.valid_last_name("Cooly")
        valid.should == false
      end

      it "should return false if last name is nil" do
        family_card = FactoryGirl.build(:family_card, last_name: nil)

        valid = family_card.valid_last_name("Cooly")
        valid.should == false
      end
    end
  end
end
