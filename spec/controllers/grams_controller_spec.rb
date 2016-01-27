require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#destroy" do
    it "shouldn't allow user who did not crete a gram to destroy it" do
      g = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, id: g.id
      expect(response).to have_http_status(:forbidden)
    end 

    it "should not let unathenticated users destroy a gram" do
      p = FactoryGirl.create(:gram)
      delete :destroy, id: p.id
      expect(response).to redirect_to new_user_session_path
    end  

    it "should allow a user to destroy grams" do
      g = FactoryGirl.create(:gram)
      sign_in g.user
      delete :destroy, id: g.id
      expect(response).to redirect_to root_path
      g = Gram.find_by_id(g.id)
      expect(g).to eq nil
    
    end

    it "should return 404 message if a gram with that specific id is not found" do
      u = FactoryGirl.create(:user)
      sign_in u
      delete :destroy, id: 'SPACEDUCK'
      expect(response).to have_http_status(:not_found)
    end
  end   

  describe "grams#update" do
    it "shouldn't let user who didn't create the gram update it" do
      p = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, id: p.id, gram: {message: 'whoa'}
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unathenticated users create a gram" do
      p = FactoryGirl.create(:gram)
      patch :update, id: p.id, gram: { message: "Hello"}
      expect(response).to redirect_to new_user_session_path 
    end  

    it "should allow users succesfully update grams" do
      p = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in p.user
      patch :update, id: p.id, gram: { message: 'Changed' }
      expect(response).to redirect_to root_path
      p.reload
      expect(p.message).to eq "Changed"
    end 

    it "should have 404 error if the gram cannot be found" do
     u = FactoryGirl.create(:user)
     sign_in u

     patch :update, id: "YOLOSWAG", gram: {message: 'Changed'}
     expect(response).to have_http_status(:not_found)

    end

    it "should render the edit form with an http status of unprocessable_entity" do
      p = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in p.user
      patch :update, id: p.id, gram: { message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      p.reload
      expect(p.message).to eq "Initial Value"
    end

  end  

  describe "grams#edit action" do
    it "shouldn't let user who did not create the gram to edit it" do
      p = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, id: p.id
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unathenticated users edit a gram" do
      p = FactoryGirl.create(:gram)
      get :edit, id: p.id
      expect(response).to redirect_to new_user_session_path 
    end  

    it "should succesfully show the form if the gram is found" do
      g = FactoryGirl.create(:gram)
      sign_in g.user
      get :edit, id: g.id
      expect(response).to have_http_status(:success)  
    end

    it "should return a 404 error message if the gram is not found" do
      u = FactoryGirl.create(:user)
      sign_in u
      get :edit, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
      
    end  
  end    

  describe "grams#show action" do
    it "should succesfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram) # this creates a db entry
      get :show, id: gram.id #get request for http /grams/:id and fills the entry
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)

    end  
  end  

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

