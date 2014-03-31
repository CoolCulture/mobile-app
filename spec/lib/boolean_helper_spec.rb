require 'spec_helper'
require "#{Rails.root}/lib/boolean_helper.rb"

describe BooleanHelper do
	let(:wrapper){
		class MyModuleWrapper
			include BooleanHelper
		end
		MyModuleWrapper.new
	}

	describe "human_to_boolean" do
		it "should return true when given 'yes'" do
			wrapper.human_to_boolean("yes").should eq(true)
		end
		
		it "should return false when given 'no'" do
			wrapper.human_to_boolean("no").should eq(false)
		end
		
		it "should be case-insensitive" do
			wrapper.human_to_boolean("NO").should eq(false)
			wrapper.human_to_boolean("YEs").should eq(true)
		end

		it "should return bad input as-is" do
			wrapper.human_to_boolean("xx").should eq("xx")
		end
	end
end