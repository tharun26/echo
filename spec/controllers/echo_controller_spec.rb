require 'rails_helper'

RSpec.describe EchoController, type: :request do
    describe "#Echo API" do
        before :each do
            @user_1_info = {:email=> "sample@gmail.com", :password=> "PasswordIsStrong1@"}
            @user_2_info = {:email=> "sample2@gmail.com", :password=> "PasswordIsStrong1@"}
            @user_3_info = {:email=> "sample3@gmail.com", :password=> "PasswordIsStrong1@"}
            @request_data = {
                "verb": 'POST',
                "path": '/greeting/1',
                "response": {
                    "code": 201,
                       "headers": {
                           "sample": "1234"
                        },
                        "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }.with_indifferent_access

            @user1 = User.new(name:"sample", email: @user_1_info[:email], password: @user_1_info[:password], id: 1).save
            @user2 = User.new(name:"sample", email: @user_2_info[:email], password: @user_2_info[:password], id: 2).save
            @user3 = User.new(name:"sample", email: @user_3_info[:email], password: @user_3_info[:password], id: 3).save
            
            @endpoint1 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:1).save 
            @endpoint2 = Endpoint.new(verb: @request_data[:verb], path: '/greeting/2', response: @request_data[:response].to_json, user_id: 1, id:2).save 
            @endpoint3 = Endpoint.new(verb: @request_data[:verb], path: '/greeting/3', response: @request_data[:response].to_json, user_id: 2, id:3).save 

            old_controller = @controller
            @controller = AuthenticationController.new
            auth = Base64.strict_encode64("#{@user_1_info[:email]}"+":"+"#{@user_1_info[:password]}")
           
            headers = {}
            headers["Authorization"] = "Basic "+auth
            post "/authenticate", params: { url: "http://localhost:3000/"}, headers: headers
            body = JSON.parse(response.body)
            @token = body['auth_token']
            @controller = old_controller
        end

        it "should respond with mock endpoing error code and body if user created endpoint exist for verb POST and path /greeting/1" do
            headers["Authorization"] = @token
            post "/greeting/1", params: { url: "http://localhost:3000/"}.to_json, headers: headers
            expect(response.status).to eq(201)
            expect(response.body).to eq("{ \"message\": \"Hello, world\" }")
        end

        it "should respond 404 if requested endpoint does not exist" do
            headers["Authorization"] = @token
            post "/greeting/3", params: { url: "http://localhost:3000/"}.to_json, headers: headers
            expect(response.status).to eq(404)
        end

    end
end