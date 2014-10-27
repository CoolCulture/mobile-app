require 'rails_helper'

describe User do
  describe ".import" do
    let(:headers) { ["email","pass_id_number","admin"] }
    
    before :each do
      FactoryGirl.create(:family_card, _id: 90000, pass_id: 90000, first_name: "Hal")
    end

    it 'should create new users when a valid CSV is imported' do
      file = create_tmp_file(["temp1@gmail.com", "90000",""])
      User.import(file)
      expect(User.count).to eq 1
      expect(User.last.family_card.first_name).to eq "Hal"
    end

    it 'should throw an error if email is missing' do
      file = create_tmp_file(["", "90000",""])
      results = User.import(file)
      expect(results[:errors].count).to eq 1
      expect(User.count).to eq 0
    end

    it 'should throw an error if pass id is missing' do
      file = create_tmp_file(["temp1@gmail.com", "",""])
      results = User.import(file)
      expect(results[:errors].count).to eq 1
      expect(User.count).to eq(0)
    end

    it 'should throw an error if the family card is already associated with another user' do
      User.create(email: "temp2@gmail.com", password: "password", password_confirmation: "password",
                  family_card_id: 90000, admin: false)

      file = create_tmp_file(["temp1@gmail.com", "90000",""])
      results = User.import(file)
      expect(results[:errors].count).to eq 1
      expect(User.count).to eq(1)
    end

    it 'should be able to create admin users' do
      file = create_tmp_file(["temp1@gmail.com", "90000","YES"])
      User.import(file)
      expect(User.count).to eq(1)
      expect(User.last.admin?).to be true
    end
  end

  def create_tmp_file(row)
    temp_file = Tempfile.new('temp_file.csv')
    CSV.open(temp_file.path, 'w') do |csv|
      csv << headers
      csv << row
    end

    temp_file
  end
end