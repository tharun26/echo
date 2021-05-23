class EndpointsController < ApplicationController
  include EndpointsHelper 
    before_action :authenticate_request
    before_action :isEndpointPresent? , only: [:update, :destroy]

    attr_reader :current_user

   # GET /endpoints
  def index
    endpoints = current_user.endpoints
    constructedResponse = construct_endpoints_response(endpoints)
    render json: { data: constructedResponse } and return
  end

  # POST /endpoints
  def create
    endpoint_params = get_endpoint_params params
    endpoint_params[:user_id] = current_user[:id]
    endpoint = Endpoint.new(endpoint_params)

    if endpoint.save
      response.headers['Location'] = "#{request.protocol}#{request.host_with_port}#{endpoint[:path]}"
      response_payload = {}
      response_payload[:data] = construct_endpoint_response(endpoint)
      render json: response_payload.to_json, status: :created
    else
      render json: endpoint.errors, status: :bad_request
    end
  end

  # PATCH/PUT /endpoints/{:id}
  def update
    endpoint_params = get_endpoint_params params
    endpoint = get_endpoint_by_id

    if endpoint.update(endpoint_params)
      response_payload = {}
      response_payload[:data] = construct_endpoint_response(endpoint)
      render json: response_payload, status: :ok
    else
      render json: endpoint.errors, status: :not_found
    end
    
  end

  # DELETE /endpoints/{:id}
  def destroy
    endpoint = get_endpoint_by_id
    if endpoint.destroy
      render json: {} , status: :no_content
    else
      render json: endpoint.errors, status: :not_found
    end
  end

  private

    def get_endpoint_by_id
      Endpoint.find_by_id(params[:id])
    end

    def isEndpointPresent?
      endpoint = Endpoint.find_by_id(params[:id])
      if endpoint.nil?
        render json: { errors:[
            {
              "code": "not_found",
              "detail": "Requested Endpoint with ID `#{params[:id]}` does not exist"
            }
          ]
        } , status: :not_found
      end
    end
end
