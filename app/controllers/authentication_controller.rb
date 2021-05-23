class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    def authenticate
        authenticate_with_http_basic do |email, password|
            command = AuthenticateUser.call(email, password)
            if command.success?
                render json: { auth_token: command.result } and return
            else
                render json: { error: command.errors }, status: :unauthorized and return
            end
        end
        render status: :unauthorized
    end

end