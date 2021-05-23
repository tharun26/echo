class EchoController < ApplicationController
  include EchoHelper
    before_action :authenticate_request

    attr_reader :current_user

    def custom_action
      endpoint = get_end_point request.method, request.path
      if endpoint
        endpoint_response = prepare_response endpoint
        render json: endpoint_response.first, status:  endpoint_response.second
      else
        render json: { errors:[
            {
              "code": "not_found",
              "detail": "Requested page `#{request.path}` does not exist"
              }
          ]
        } , status: :not_found
      end
     
    end

    private
      def get_end_point (verb, path)
        # endpoints = current_user.endpoints
        # endpoints.find_by(verb: verb, path: path)
        current_user.endpoints.find_by(verb: verb, path: path)
      end
  end