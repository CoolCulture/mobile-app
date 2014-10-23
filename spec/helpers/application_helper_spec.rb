require 'rails_helper'

describe ApplicationHelper do
	describe "boolean_to_human" do
		it "should return 'Yes' when passed true" do
      expect(boolean_to_human(true)).to eq("Yes")
		end
		
		it "should return 'No' when passed false" do
      expect(boolean_to_human(false)).to eq("No")
		end
	end
end