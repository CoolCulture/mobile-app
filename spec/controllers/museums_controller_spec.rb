require 'spec_helper'

describe MuseumsController do
  
  describe "import" do
    it "should import CSV and create museums" do
      csv_to_import = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'museums.csv'), "text/csv")

      post :import, file: csv_to_import

      flash[:notice].should eq("Museums imported successfully.")
      Museum.count.should == 5
    end
  end

  describe "GET index" do
    it "assigns @museums" do
      museum = FactoryGirl.create(:museum)
      get :index
      expect(assigns(:museums)).to eq([museum])
    end
  end

  describe "GET new" do
    it "should get new" do
      get :new
      expect(response).to render_template("new")
    end

    it "should create new museum" do
      get :new
      response.should be_ok
      assigns[:museum].should be_present
    end
  end

  describe "POST create" do
    subject{post :create, museum: FactoryGirl.attributes_for(:museum)}

    it "should create museum" do
      expect{subject}.to change(Museum, :count).by(1)
    end

    it "should redirect to show page for museum with create success message" do
      subject.should redirect_to assigns(:museum)
      flash[:notice].should eq("Museum was successfully created.")
    end
  end

  describe "GET show" do
    it "should return success" do
      museum = FactoryGirl.create(:museum)
      get :show, id: museum.id
      response.should be_ok
    end
  end

  describe "GET edit" do
    it "should return success" do
      museum = FactoryGirl.create(:museum)
      get :edit, id: museum.id
      response.should be_ok
    end
  end

  describe "PATCH update" do    
    it "should update museum" do
      museum = FactoryGirl.create(:museum)
      patch :update, id: museum.id, museum: FactoryGirl.attributes_for(:museum, name:"A New Museum Name")
      museum.reload
      museum.name.should eq("A New Museum Name")

      response.should redirect_to assigns(:museum)
    end
  end

  describe "DELETE" do
    it "should destroy museum" do
      museum = FactoryGirl.create(:museum)
      expect{post :destroy, id: museum.id}.to change(Museum, :count).by(-1)
    end
  end
end