require 'rails_helper'

describe Museum do
  describe "slug" do
    it "should find museum by slug" do
      museum = FactoryGirl.build(:museum)

      museum.save

      museum_slug = Museum.find("the-museum-of-modern-art")
      expect(museum_slug.name).to eq("The Museum of Modern Art")
    end

    it "should generate slug with non-alphanumeric characters removed" do
      museum = FactoryGirl.build(:museum, name: "New York's Museum")

      museum.save

      museum_slug = Museum.find("new-yorks-museum")
      expect(museum_slug.name).to eq("New York's Museum")
    end

     it "should set name_id to the museum slug" do
      museum = FactoryGirl.build(:museum)

      museum.save

      museum_after_save = Museum.find("the-museum-of-modern-art")
      expect(museum_after_save.name_id).to eq(museum.slug)
    end

    it "should update name_id when name is changed" do
      museum = FactoryGirl.create(:museum)

      museum.reload
      museum.update(name: "The Museum of Modern Art Test")

      expect(museum.name_id).to eq(museum.slug)
    end
  end

  describe "before save" do
    it "should remove empty strings from hours" do
      museum = FactoryGirl.build(:museum, hours: ['9AM-5PM M-F', '10AM-9PM Sat', ''])

      museum.save

      expect(museum.hours).to eq(['9AM-5PM M-F', '10AM-9PM Sat'])
    end

    it "should order subway lines" do
      museum = FactoryGirl.build(:museum, subway_lines: ['A','B','1','7','3','C','D','Z','L','E','F','G'])

      museum.save

      expect(museum.subway_lines).to eq(['1','3','7','A','C','E','B','D','F','G','Z','L'])
    end

    it "should return all unrecognized subway lines at end of array" do
      museum = FactoryGirl.build(:museum, subway_lines: ['A','B','Railway','1','7'])

      museum.save

      expect(museum.subway_lines).to eq(['1','7','A','B','Railway'])
    end
  end
end
