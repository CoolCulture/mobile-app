require 'spec_helper'

describe Museum do
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:phone_number)}
  it {should validate_presence_of(:address)}
  it {should validate_presence_of(:borough)}
  it {should validate_presence_of(:site_url)}
  it {should validate_presence_of(:image_url)}
  it {should validate_presence_of(:hours)}
  it {should validate_presence_of(:categories)}

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

    it "should update name_id when name is changed" do
      museum = FactoryGirl.create(:museum)

      museum.reload
      museum.update(name: "The Museum of Modern Art Test")


      museum.name_id.should == museum.slug
    end
  end

  describe "before save" do
    it "should remove empty strings from hours" do
      museum = FactoryGirl.build(:museum, hours: ['9AM-5PM M-F', '10AM-9PM Sat', ''])

      museum.save

      museum.hours.should == ['9AM-5PM M-F', '10AM-9PM Sat']
    end

    it "should order subway lines" do
      museum = FactoryGirl.build(:museum, subway_lines: ['A','B','1','7','3','C','D','Z','L','E','F','G'])

      museum.save

      museum.subway_lines.should == ['1','3','7','A','C','E','B','D','F','G','Z','L']
    end

    it "should return all unrecognized subway lines at end of array" do
      museum = FactoryGirl.build(:museum, subway_lines: ['A','B','Railway','1','7'])

      museum.save

      museum.subway_lines.should == ['1','7','A','B','Railway']
    end
  end
end
