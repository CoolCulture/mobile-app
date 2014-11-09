require 'rails_helper'

describe FamilyCard do
  describe ".import" do
    let(:headers) { ["family_name","type","program_name_(1st_line)","program_name_(2nd_line)",
                    "pass_id_number","adult_1","adult_2","child_1","child_2"] }
    before :each do
      @file = Tempfile.new('users.csv')
      CSV.open(@file.path, 'w') do |csv|
        csv << headers
        
        letter = "A"
        10.times do |i|
          csv << ["N/A","FAMILY","PROGRAM NAME","",
                  "1000#{i}","First #{letter}","Last #{letter}","WES",""]
          letter = letter.succ
        end
      end
    end

    after :each do
      @file.unlink
    end

    it 'should create new family cards when a valid CSV is imported' do
      FamilyCard.import(@file)
      expect(FamilyCard.count).to eq(10)
    end

    it 'should join the second program line with parenthesis if there is one' do
      second_line = create_tmp_file(["N/A","FAMILY","PROGRAM NAME","SECOND LINE","90000",
                                     "First Adult","Last Adult","","",])

      FamilyCard.import(second_line)
      family_card = FamilyCard.find(90000)
      expect(family_card.organization_name).to eq "PROGRAM NAME (SECOND LINE)"

      second_line.unlink
    end

    it 'should alphabetize the last names if there are two adults' do
      alphabetize = create_tmp_file(["N/A","FAMILY","PROGRAM NAME","","90000",
                                     "First Adult Smith","Last Adult Jones","",""])

      FamilyCard.import(alphabetize)
      family_card = FamilyCard.find(90000)
      
      expect(family_card.last_name).to eq "Jones/Smith"
      expect(family_card.first_name).to eq "Last/First"
      
      alphabetize.unlink
    end

    it 'should create a loaner pass if there are no adults but a pass id' do
      loaner_pass = create_tmp_file(["LOANER PASS","FAMILY","PROGRAM NAME","","90000",
                                     "","","",""])

      FamilyCard.import(loaner_pass)
      family_card = FamilyCard.find(90000)
      
      expect(family_card.last_name).to eq "LOANER PASS"
      expect(family_card.first_name).to eq "LOANER PASS"
      
      loaner_pass.unlink
    end

    it 'should require family pass IDs' do
      no_pass_id = create_tmp_file(["FAMILY NAME","FAMILY","PROGRAM NAME","SECOND LINE","",
                                    "First Adult","Last Adult","",""])
      errors = FamilyCard.import(no_pass_id)
      expect(errors["FAMILY NAME"]).to include("Something about this isn't right: ")

      no_pass_id.unlink
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
