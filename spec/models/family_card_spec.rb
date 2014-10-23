require 'rails_helper'

describe FamilyCard do
  describe ".import" do
    before :each do
      @file = Tempfile.new('users.csv')
      CSV.open(@file.path, 'w') do |csv|
        csv << ["pass_id","first_name","last_name","expiration","organization_name","language","email"]
        10.times do |i|
          csv << ["1000#{i}","First#{i}","Last#{i}","","BlueRidge Foundation","","temp#{i}@gmail.com"]
        end
      end
    end

    after :each do
      @file.unlink
    end

    it 'should create new users when a valid CSV is imported' do
      FamilyCard.import(@file)
      expect(FamilyCard.count).to eq(10)
    end

    it 'should associate users and CSVs correctly' do
      FamilyCard.import(@file)
      family_card = FamilyCard.find(10001)
      expect(family_card.user.email).to eq("temp1@gmail.com")
    end

    it 'should not allow duplicates' do
      same_users = Tempfile.new('same_users.csv')
      CSV.open(same_users.path, 'w') do |csv|
        csv << ["pass_id","first_name","last_name","expiration","organization_name","language","email"]
        csv << ["10001","First1","Last1","","BlueRidge Foundation","","temp1@gmail.com"]
      end
      FamilyCard.import(@file)

      errors = FamilyCard.import(same_users)
      expect(errors.count).to eq(1)
      
      same_users.unlink
    end
  end
end
