require 'spec_helper'

describe ApplicationHelper do
	describe "human_boolean" do
		it "should return 'Yes' when passed true" do
			human_boolean(true).should eq("Yes")
		end
		it "should return 'No' when passed false" do
			human_boolean(false).should eq("No")
		end
	end
end