require 'rails_helper'

RSpec.describe Endpoint, :type => :model do

    describe '#validates' do
        it 'presence of verb' do
            record = Endpoint.new
            record.verb = '' 
            record.validate 
            expect(record.errors[:verb]).to include("can't be blank")
    
            record.verb = 'GET'
            record.validate 
            expect(record.errors[:verb]).to_not include("can't be blank")

            record.verb = 'PUT_SOMETHING'
            record.validate 
            expect(record.errors[:verb]).to include("PUT_SOMETHING is not a valid HTTP Method")
    
            record.verb = 100
            record.validate 
            expect(record.errors[:verb]).to include("100 is not a valid HTTP Method")
        end

        it 'presence of path' do
            record = Endpoint.new
            record.path = '' 
            record.validate 
            expect(record.errors[:path]).to include("can't be blank")
    
            record.path = '/greeting/1'
            record.validate 
            expect(record.errors[:path]).to_not include("can't be blank")

            record = Endpoint.new
            record.path = 'greeting/1'
            record.validate 
            expect(record.errors[:path]).to include("Path attribute needs to start with /")
        end

        it 'presence of endpoint_response code' do
            record = Endpoint.new
            record.response = {"code"=> "string"}.to_json
            record.validate 
            expect(record.errors[:response]).to include("response code must have value of data type integer")
    
            record.response = {"code_new"=>200}.to_json 
            record.validate 
            expect(record.errors[:response]).to include("response code can't be blank")

            record = Endpoint.new
            record.response = {"code"=>200}.to_json
            record.validate 
            expect(record.errors[:response]).to_not include("can't be blank")

            record = Endpoint.new
            record.response = {"body"=>200}.to_json
            record.validate 
            expect(record.errors[:response]).to include("response body value must be of data type string")
            
            record = Endpoint.new
            record.response = {"body"=>"sample"}.to_json
            record.validate 
            expect(record.errors[:response]).to_not include("response body value must be of data type string")

            record = Endpoint.new
            record.response = {"headers"=>{"sample"=>1234}}.to_json
            record.validate 
            expect(record.errors[:response]).to include("response headers attributes: sample must have value of data type string")
        end
    end

    describe '#validate endpoint' do
        before(:each) do
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
            User.new(name:"sample", email: "sample@gmail.com", password_digest: "sample", id: 1).save

        end

        it 'should not allow verb and path combination if endpoint with same combination already present during create operation' do
            record1 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:1).save
            record2 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:2)
            result = record2.save
            expect(record2.errors[:verb]).to include("Endpoint already exist for the combination verb: GET and path: /greeting/1")
        end
            
        it 'should not allow verb and path combination if endpoint with same combination already present during update operation' do
            record1 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:1).save
            record2 = Endpoint.new(verb: @request_data[:verb], path: "/greeting/2", response: @request_data[:response].to_json, user_id: 1, id:2)
            record2.save
            result = record2.update(verb: @request_data[:verb], path: "/greeting/1", response: @request_data[:response].to_json, user_id: 1, id:2)
            expect(record2.errors[:verb]).to include("Endpoint already exist for the combination verb: GET and path: /greeting/1")
        end

        it 'should allow verb and path combination if endpoint with same combination already present during create operation' do
            record1 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:1).save
            record2 = Endpoint.new(verb: "POST", path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:2)
            result = record2.save
            expect(record2.errors[:verb]).to_not include("Endpoint already exist for the combination verb: GET and path: /greeting/1")
        end

        it 'should allow verb and path combination if endpoint with same combination already present during update operation' do
            record1 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:1).save
            record2 = Endpoint.new(verb: @request_data[:verb], path: "/greeting/2", response: @request_data[:response].to_json, user_id: 1, id:2)
            record2.save
            result = record2.update(verb: @request_data[:verb], path: "/greeting/3", response: @request_data[:response].to_json, user_id: 1, id:2)
            expect(record2.errors[:verb]).to_not include("Endpoint already exist for the combination verb: GET and path: /greeting/1")
        end

    end

    describe 'endpoint and user model Relation' do
        before(:each) do
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
            User.new(name:"sample", email: "sample@gmail.com", password_digest: "sample", id: 1).save
            User.new(name:"sample", email: "sample2@gmail.com", password_digest: "sample", id: 2).save

        end
        it 'should delete endpoints when corresponding user gets deleted' do
            record1 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:1).save
            record2 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 1, id:2).save
            record3 = Endpoint.new(verb: @request_data[:verb], path: @request_data[:path], response: @request_data[:response].to_json, user_id: 2, id:3).save
            User.destroy(1)
            print(Endpoint.find_by_id(3))
            record1 = Endpoint.find_by_id(1)
            record2 = Endpoint.find_by_id(2)
            record3 = Endpoint.find_by_id(3)
            expect(record1).to eq nil
            expect(record2).to eq nil
            expect(record3).to_not eq nil
        end
    end
end