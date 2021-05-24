
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    
    describe "#user/register endpoint" do
        before :each do 
            #allow(controller).to receive(:authenticate_request?).and_return(true)
        end 

        it 'should create a user on POST request and response is 201' do
            expect {
            post :register, params: {  name: 'sample', email: 'sample@gmail.com', password: 'Password@123' }
            }.to change(User, :count).by(1)
            expect(response.status).to eq(201)
        end

        it 'should not create a user on POST request and response is 400' do
            expect {
            post :register, params: {  name: 'sample', email: 'sample@gmail.com', password: 'Password@' }
            }.to change(User, :count).by(0)
            expect(response.status).to eq(400)
        end
    end

end