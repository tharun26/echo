class User < ApplicationRecord
    validates_presence_of :name, :email
    validates :email, uniqueness: true
    validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

    has_many :endpoints ,dependent: :destroy
    has_secure_password
    validate :password_requirements , on: :create


    private

    def password_requirements
        if password.present?
            rules = {
                "must contain at least one lowercase letter"  => /[a-z]+/,
                "must contain at least one special character" => /[^A-Za-z0-9]+/,
                "must contain at least one uppercase letter"  => /[A-Z]+/,
                "must contain at least one digit"             => /\d+/,
            }
            rules.each do |message, regex|
                errors.add( :password, message ) unless password.match( regex ) 
            end
            errors.add( :password, "length must be between 6 to 20 characters" ) if !((6...20).include? password.length)
            return
        end
    end
      
end
