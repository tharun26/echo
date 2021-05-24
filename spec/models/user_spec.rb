require 'rails_helper'

RSpec.describe User, :type => :model do

    describe '#validates' do
        before(:each) do
            @password = 'PasswordIsStrong1@'
        end
        it 'presence of name' do
            record = User.new
            record.name = '' 
            record.password =  @password
            record.validate 
            expect(record.errors[:name]).to include("can't be blank")
    
            record.name = 'Jack'
            record.validate 
            expect(record.errors[:name]).to_not include("can't be blank")
        end

        it 'presence of email' do
            record = User.new
            record.email = '' 
            record.password =  @password 
            record.validate 
            expect(record.errors[:email]).to include("can't be blank")
    
            record.email = 'Jack@gmail.com'
            record.validate 
            expect(record.errors[:email]).to_not include("is invalid")

            record.email = 'Jack'
            record.validate 
            expect(record.errors[:email]).to include("is invalid")
        end

        it 'presence of password' do
            record = User.new
            record.password =  @password 
            record.validate 
            expect(record.errors[:password].length).to equal(0)
            
            record = User.new
            record.password =  "sample" 
            record.validate 
            expect(record.errors[:password]).to include("must contain at least one special character")
            expect(record.errors[:password]).to include("must contain at least one uppercase letter")
            expect(record.errors[:password]).to include("must contain at least one digit")

            record.password =  "SAM" 
            record.validate 
            expect(record.errors[:password]).to include("must contain at least one special character")
            expect(record.errors[:password]).to include("must contain at least one lowercase letter")
            expect(record.errors[:password]).to include("must contain at least one digit")
            expect(record.errors[:password]).to include("length must be between 6 to 20 characters")
        end
    end
end