require 'spec_helper'
include ActionDispatch::TestProcess

describe Admin::MuseumsController do

  before(:each) do
    user = FactoryGirl.create(:user)
    user.update_attributes(admin: true)
    sign_in user
  end

  describe "import" do
    it "should import CSV and create museums" do
      csv_to_import = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'museums.csv'), "text/csv")
      post :import, file: csv_to_import

      expect(flash[:notice]).to eq("Museums imported successfully.")
      expect(Museum.count).to eq(5)
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
      expect(response).to be_ok
      expect(assigns[:museum]).to be_present
    end
  end

  describe "POST create" do
    subject{ post :create,
             museum: {:name => "fake museum", :phone_number => "(555) 555-555", 
                      :address => "123 Fakey Fake St., Brooklyn, NY 00000", 
                      :borough => "Brooklyn", :site_url => "http://fake.com",
                      :image_url => "http://image.fake.is/fake.png",
                      :hours => ["fake"], :categories => ["category"]}, 
             format: :json }

    it "should create museum" do
      expect{subject}.to change(Museum, :count).by(1)
    end

    it "should redirect to show page for museum with create success message" do
      expect(subject).to redirect_to(admin_museum_path(Museum.first))
      expect(flash[:notice]).to eq("Museum was successfully created.")
    end
  end

  describe "GET show" do
    it "should return success" do
      museum = FactoryGirl.create(:museum)
      get :show, id: museum.id
      expect(response).to be_ok
    end
  end

  describe "GET edit" do
    it "should return success" do
      museum = FactoryGirl.create(:museum)
      get :edit, id: museum.id
      expect(response).to be_ok
    end
  end

  describe "PATCH update" do
    it "should update museum and update slug name" do
      museum = FactoryGirl.create(:museum)
      patch :update, id: museum.id, museum: FactoryGirl.attributes_for(:museum, name:"A New Museum Name")
      museum.reload

      expect(museum.name).to eq("A New Museum Name")
      expect(museum.slug).to eq("a-new-museum-name")
      expect(response).to redirect_to(admin_museum_path(museum))
    end
  end

  describe "DELETE" do
    it "should destroy museum" do
      museum = FactoryGirl.create(:museum)
      expect{post :destroy, id: museum.id}.to change(Museum, :count).by(-1)
    end
  end
end
