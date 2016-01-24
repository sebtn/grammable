require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#index action" do
    it "should succesfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end  
  	it "should succesfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

  		get :new
  		expect(response).to have_http_status(:success)
  	end
  end	

  describe "grams#create action" do
    it "should require users to be logged in" do 
      post :create, gram: { message: "Hello!" }
    end  
    it "should create a new gram in our database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: {message: 'Hello!'}
      expect(response).to redirect_to root_path
      
      gram = Gram.last                 
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
      #which should be the gram that was just created. 
      #The second line -> hello! = hello! verifies the message is what we just posted.
      # The first line -> Gram.last that was added loads the last gram in our database, 
    end  

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: {message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end  

  end
  
 
end  

