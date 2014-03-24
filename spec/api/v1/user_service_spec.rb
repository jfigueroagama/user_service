require 'spec_helper'

describe "user service" do
  
  before do
    User.delete_all
  end
  
  describe "GET on /api/v1/users/:name" do
    before do
      User.create(name: "paul",
                  email: "paul@example.com",
                  password: "strongpass",
                  bio: "rubyist"
                  )
      @user = User.find_by_name("paul")
    end
    
    let(:url) { "/api/v1/users/#{@user.name}" }
    
    it "should return a user by name" do
      get "#{url}.json", {:name => "paul"}
      response.should be_ok
      attributes = JSON.parse(response.body)
      attributes["name"].should eq "paul"
    end
    it "should return a user with email" do
      get "#{url}.json", {:name => "paul"}
      response.should be_ok
      attributes = JSON.parse(response.body)
      attributes["email"].should eq "paul@example.com"
    end
    it "should return a user bio" do
     get "#{url}.json", {:name => "paul"}
      response.should be_ok
      attributes = JSON.parse(response.body)
      attributes["bio"].should eq "rubyist"
    end
    it "should not return user's password" do
      get "#{url}.json", {:name => "paul"}
      response.should be_ok
      attributes = JSON.parse(response.body)
      attributes["password"].should be_nil
    end
    it "should return 404 for a user that does not exist" do
      get "#{url}.json", {:name => "foo"}
      response.status.should eql(404)
    end
  end
  
  describe "POST on /api/v1/users" do
    let(:url) { "/api/v1/users" }
    it "should create a user" do
      post "#{url}.json", :user => {:name => "trotter", 
                                    :email => "trotter@example.com", 
                                    :password => "whatever", 
                                    :bio => "rubyist"}
      response.status.should eql(201)
      user = User.find_by_name("trotter")
      response.body.should eql(user.to_json)
      route = "/api/v1/users/#{user.id}"
      response.headers["Location"].should eql(route)
      
      url1 = "#{url}/#{user.name}"
      get "#{url1}.json", {:name => "trotter"}
      attributes = JSON.parse(response.body)
      attributes["name"].should eql("trotter")
      attributes["email"].should eql("trotter@example.com")
      attributes["bio"].should eql("rubyist")
    end
    it "should not create a user with invalid request" do
      post "#{url}.json", :user =>{ }
      response.status.should eql(400)
      expect(response.body).to include("Bad request")
    end
  end
  
  describe "PUT on /api/v1/users" do
    before do
      @user = User.create(:name => "bryan",
                         :email => "bryan@example.com",
                         :password => "whatever",
                         :bio => "javaist")
    end
    it "should update a user" do
      url = "/api/v1/users/#{@user.id}"
      put "#{url}.json", :user => {:bio => "rubyist"}
      # request processed successfully but returning no content
      response.status.should eql(204)
      
      @user.reload
      get "#{url}.json", {:name => "bryan"}
      attributes = JSON.parse(response.body)
      attributes["bio"].should eql("rubyist")
    end
    it "should not update a user" do
      url = "/api/v1/users/#{@user.id}"
      put "#{url}.json", :user => {:name => ""}
      # cannot process the entity (model validations failed)
      response.status.should eql(422)
    end
    it "should not update a user not in DB" do
      url = "/api/v1/users/200"
      put "#{url}.json", :user => {:name => "james"}
      # The put request ends successfully even though the user was not found
      response.status.should eql(204)

      get "#{url}.json", {:name => "james"}
      response.status.should eql(404)
    end
  end
  
  describe "DELETE on /api/v1/users" do
    before do
      @user = User.create(:name => "bryan",
                         :email => "bryan@example.com",
                         :password => "whatever",
                         :bio => "javaist")
    end
    it "deletes a user" do
      url = "/api/v1/users/#{@user.id}"
      delete "#{url}.json", :user => {:name => "bryan"}
      response.status.should eql(204)
      
      get "#{url}.json", {:name => "bryan"}
      response.status.should eql(404)
    end
  end
end
