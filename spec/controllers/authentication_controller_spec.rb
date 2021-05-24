
require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
    
    describe "#authenticate endpoint" do
        before :each do 
            @user = User.new(name:"sample", email: "sample@gmail.com", password: "PasswordIsStrong1@", id: 1).save
            auth = Base64.strict_encode64("sample@gmail.com"+":"+"PasswordIsStrong1@")
            @auth_token ="Basic "+ auth
        end 

        it 'should authenticate user if already avaiable' do
            request.headers["Authorization"] = @auth_token
            post :authenticate, params: { }
            expect(response.status).to eq(200) 
            body = JSON.parse(response.body)
            expect(body['auth_token'].present?).to equal(true)
        end

        it 'should not create a user on POST request and response is 400' do
            request.headers["Authorization"] = "Basic d2FtcGxlQGdtYWlsLmNvbTpQYXNzd29yZElzU3Ryb25nMUA="
            post :authenticate, params: { }
            expect(response.status).to eq(401) 
            body = JSON.parse(response.body)
            expect(body['error']['user_authentication'] == "invalid credentials").to equal(true)
        end
    end

end