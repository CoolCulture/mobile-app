require 'spec_helper'

describe Checkin do
  it { should belong_to(:museum) }
  it { should belong_to(:family_card) }

  it {should validate_presence_of(:number_of_children)}
  it {should validate_presence_of(:number_of_adults)}

end
