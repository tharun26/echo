class User < ApplicationRecord
    validates_presence_of :name, :email, :password_digest
    validates :email, uniqueness: true
    validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

    has_many :endpoints ,dependent: :destroy
    has_secure_password
end
