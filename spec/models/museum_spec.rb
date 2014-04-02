require 'spec_helper'

describe Museum do
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:phoneNumber)}
  it {should validate_presence_of(:address)}
  it {should validate_presence_of(:borough)}
  it {should validate_presence_of(:siteUrl)}
  it {should validate_presence_of(:imageUrl)}
  it {should validate_presence_of(:hours)}
  it {should validate_presence_of(:subwayLines)}
  it {should validate_presence_of(:categories)}
  it {should validate_presence_of(:wifi)}
  it {should validate_presence_of(:handicapAccessible)}
  it {should validate_presence_of(:handsOnActivity)}

  it {should validate_uniqueness_of(:name)}

  describe "slug" do
    it "should find museum by slug" do
      museum = FactoryGirl.build(:museum)

      museum.save

      museum_slug = Museum.find("the-museum-of-modern-art")
      museum_slug.name.should == "The Museum of Modern Art"
    end

    it "should generate slug with non-alphanumeric characters removed" do
      museum = FactoryGirl.build(:museum, name: "New York's Museum")

      museum.save

      museum_slug = Museum.find("new-yorks-museum")
      museum_slug.name.should == "New York's Museum"
    end

     it "should set name_id to the museum slug" do
      museum = FactoryGirl.build(:museum)

      museum.save

      museum_after_save = Museum.find("the-museum-of-modern-art")
      museum_after_save.name_id.should == museum.slug
    end
  end

  describe "before save" do
    it "should remove empty strings from hours" do
      museum = FactoryGirl.build(:museum, hours: ['9AM-5PM M-F', '10AM-9PM Sat', ''])

      museum.save

      museum.hours.should == ['9AM-5PM M-F', '10AM-9PM Sat']
    end
  end
end
