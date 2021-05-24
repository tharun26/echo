class UsersController < ApplicationController
    skip_before_action :authenticate_request

    def register
        @user = User.create(user_params)
        if @user.save
            response = { message: 'User created successfully'}
            render json: response, status: :created 
        else
            render json: @user.errors, status: 400
        end 
    end

    private

    def user_params
        params.permit(
            :name,
            :email,
            :password
        )
    end
end