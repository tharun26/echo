
require 'rails_helper'

RSpec.describe EndpointsController, type: :controller do
    
    describe "GET endpoint" do
      it "returns a successful response" do
        #get :index
        # expect(response).to be_successful
        
      end
      
      it 'render a list of endpoint' do
        hotel1, hotel2 = create(:endpoint), create(:endpoint)
        get :index
        expect(assigns(:endpoint)).to match_array([endpoint, endpoint])
      end
    
   
    #   it "assigns @users" do
    #     user = User.create(name: “Test user”)
    #     get :index
    #     expect(assigns(:users)).to eq([user])
    #   end
  
    #   it "renders the index template" do
    #     get :index
    #     expect(response).to render_template("index")
    #   end
    end

    # describe "GET #index" do
    #     it "populates an array of endpoints"
    #     it "renders the :index view"
    # end
    
    # describe "GET #show" do
    #     it "assigns the requested contact to @contact"
    #     it "renders the :show template"
    # end
    
    # describe "GET #new" do
    #     it "assigns a new Contact to @contact"
    #     it "renders the :new template"
    # end
    
    # describe "POST #create" do
    #     context "with valid attributes" do
    #     it "saves the new contact in the database"
    #     it "redirects to the home page"
    #     end
        
    #     context "with invalid attributes" do
    #     it "does not save the new contact in the database"
    #     it "re-renders the :new template"
    #     end
    # end

  end