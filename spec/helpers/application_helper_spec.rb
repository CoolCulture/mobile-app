require 'spec_helper'

describe ApplicationHelper do
	describe "boolean_to_human" do
		it "should return 'Yes' when passed true" do
			boolean_to_human(true).should eq("Yes")
		end
		
		it "should return 'No' when passed false" do
			boolean_to_human(false).should eq("No")
		end
	end
end