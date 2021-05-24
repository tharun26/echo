require 'rails_helper'

RSpec.describe EndpointsController, type: :controller do
    
    describe "#endpoint API" do

        mock_response_list_endpoints = {:data=>[{:type=>"endpoints", :id=>3, :attributes=>{:verb=>"GET", :path=>"/greeting/3", :response=>{:code=>201, :headers=>{:sample=>"1234"}, :body=>"\"{ \"message\": \"Hello, world\" }\""}}}]}
        mock_request_payload = {
            :data => {
              :type=> "endpoints",
              :attributes=> {
                :verb=> "GET",
                :path=> "/greeting/3",
                :response=> {
                  :code=> 201,
                  :headers=> {
                    :sample=> "1234"
                  },
                  :body => "\"{ \"message\": \"Hello, world\" }\""
                }
              }
            }
        }.with_indifferent_access
        mock_request2_payload = {
              :type=> "endpoints",
              :attributes=> {
                :verb=> "GET",
                :path=> "/greeting/3",
                :response=> {
                  :code=> 201,
                  :headers=> {
                    :sample=> "1234"
                  },
                  :body => "\"{ \"message\": \"Hello, world\" }\""
                }
              }
        }.with_indifferent_access
    
        before :each do 
            @user_1_info = {:email=> "sample@gmail.com", :password=> "PasswordIsStrong1@"}
            @user_2_info = {:email=> "sample2@gmail.com", :password=> "PasswordIsStrong1@"}
            @user_3_info = {:email=> "sample3@gmail.com", :password=> "PasswordIsStrong1@"}
            @request_data = {
                "verb": 'GET',
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
            request.headers["Authorization"] = "Basic "+auth
            post :authenticate, params: { }
            body = JSON.parse(response.body)
            @token = body['auth_token']
            @controller = old_controller


        end 

        context "GET Endpoint" do
            it 'test_server_to_respond_with_http_ok' do
                request.headers["Authorization"] = @token
                get :index, params: { }
                body = JSON.parse(response.body)
                expect(response.status).to eq(200) 
            end

            it 'test_server_to_respond_with_json_body' do
                request.headers["Authorization"] = @token
                get :index, params: { }
                begin
                    body = JSON.parse(response.body)
                rescue JSON::ParserError
                    is_not_json = true
                    expect(is_not_json).to eq(false)
                end
                expect(response.status).to eq(200) 
            end

            it 'test_server_to_respond_with_empty_list' do
                old_controller = @controller

                @controller = AuthenticationController.new
                auth = Base64.strict_encode64("#{@user_3_info[:email]}"+":"+"#{@user_3_info[:password]}")
                request.headers["Authorization"] = "Basic #{auth}"
                post :authenticate, params: { }
                body = JSON.parse(response.body)
                token = body['auth_token']
                @controller = old_controller

                request.headers["Authorization"] = token
                get :index, params: { }
                body = JSON.parse(response.body, symbolize_names: true)
                expect(body[:data]).to eq([]) 
            end

            it 'test_server_to_respond_with_mock_endpoint_list' do
                old_controller = @controller
            
                @controller = AuthenticationController.new
                auth = Base64.strict_encode64("#{@user_2_info[:email]}"+":"+"#{@user_2_info[:password]}")
                request.headers["Authorization"] = "Basic #{auth}"
                post :authenticate, params: { }
                body = JSON.parse(response.body)
                token = body['auth_token']
                @controller = old_controller

                request.headers["Authorization"] = token
                get :index, params: { }
                body = JSON.parse(response.body, symbolize_names: true)
                expect(body[:data].length).to eq(1)
                expect(body).to eq(mock_response_list_endpoints)
            end
        end

        context "Create Endpoint" do
            it "test_server_to_implement_create_endpoint" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                post :create, params: mock_request_payload, format: :json
                body = JSON.parse(response.body)
                expect(response.status).to eq(201) 
            end
        
            it "test_server_to_respond_with_http_created" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                post :create, params: mock_request_payload, format: :json
                body = JSON.parse(response.body)
                expect(response.status).to eq(201)
            end
        
            it "test_server_to_refuse_to_create_duplicate_endpoint" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                post :create, params: mock_request_payload, format: :json
                post :create, params: mock_request_payload, format: :json
                body = JSON.parse(response.body)
                expect(response.status).to eq(422)
            end
        
            it "test_server_to_refuse_invalid_http_verbs" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                mock_request_payload[:data][:attributes][:verb] = "PUT_AWESOME"
                post :create, params: mock_request_payload, format: :json
                body = JSON.parse(response.body)
                expect(response.status).to eq(422)
            end

            it "test_server_to_refuse_invalid_path" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                mock_request_payload[:data][:attributes][:PATH] = "greeting/1"
                post :create, params: mock_request_payload, format: :json
                body = JSON.parse(response.body)
                expect(response.status).to eq(422)
            end         
        end

        context "Update Endpoint" do
            it "test_server_to_apply_requested_changes" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                mock_request2_payload[:attributes][:verb] = "PATCH"
                put :update, params: {:id => 2, :data => mock_request2_payload}
                body = JSON.parse(response.body)
                expect(response.status).to eq(200)
            end  

            it "test_server_to_respond_with_http_ok" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                mock_request2_payload[:attributes][:verb] = "PATCH"
                put :update, params: {:id => 2, :data => mock_request2_payload}
                body = JSON.parse(response.body)
                expect(response.status).to eq(200)
            end  
        
            it "test_server_to_refuse_invalid_http_verbs" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                mock_request2_payload[:attributes][:verb] = "PATCH_AWESOME"
                put :update, params: {:id => 2, :data => mock_request2_payload}
                body = JSON.parse(response.body)
                expect(response.status).to eq(422)
            end  
        
            it "test_server_to_refuse_invalid_path" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                mock_request2_payload[:attributes][:path] = "greeting/"
                put :update, params: {:id => 2, :data => mock_request2_payload}
                body = JSON.parse(response.body)
                expect(response.status).to eq(422)
            end    
        end

        context "Delete Endpoint" do
            it "test_server_to_implement_delete_endpoint" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                delete :destroy, params: {:id => 1}
                body = JSON.parse(response.body)
                expect(response.status).to eq(204)
            end
            it "test_server_to_respond_with_http_no_content" do
                request.headers["Authorization"] = @token
                request.headers["Content-Type"] = "application/json"
                delete :destroy, params: {:id => 5}
                body = JSON.parse(response.body)
                expect(response.status).to eq(404)
            end   
        end

    end
  end