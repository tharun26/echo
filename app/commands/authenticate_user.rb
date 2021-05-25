class AuthenticateUser
    prepend SimpleCommand

    def initialize(email, password)
        @email = email
        @password = password
    end
    
    def call
        JsonWebToken.encode(user_id: user.id) if user
    end
    
    private
    
    attr_accessor :email, :password
    
    def user
        #retrieve the user id using email as key from Redis server
        #avoids database call to find the user based on email using cache
        cached_user_id = Redis.new.get email
        if cached_user_id.present?
            user = User.find_by_id(cached_user_id)
        else
            user = User.find_by_email(email)
        end

        return user if user && user.authenticate(password)

        errors.add :user_authentication, 'invalid credentials'
        nil
    end
end