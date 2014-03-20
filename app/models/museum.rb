class Museum
  include Mongoid::Document
  field :name, type: String
  field :phoneNumber, type: String
  field :address, type: String
  field :borough, type: String
  field :website, type: String
  field :hours, type: Array
  field :subwayLines, type: Array
  field :busLines, type: Array
end
