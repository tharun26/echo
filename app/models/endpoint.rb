class Endpoint < ApplicationRecord
    validates_presence_of :verb, :path, :response, :user_id, presence: true
    validates_presence_of :user_id, presence: false, on: :update
    
    validates :verb, :inclusion => { :in => %w(GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE PATCH), 
        :message => "%{value} is not a valid HTTP Method" },  :if => :verb?
    validates :path, format: { with: /\A\// ,  message: "Path attribute needs to start with /" }
    validate :validate_endpoint_response
    validate :endpoint_present? , on: [:create, :update]

    belongs_to :user

    private

    # Validates users response provided by user
    def validate_endpoint_response
        begin
            return if response.nil?
            res = JSON.parse(response)
            
            if  res["code"].present?
                errors.add(:response, 'response code must have value of data type integer')  if !res["code"].is_a? Integer
            else
                errors.add(:response, "response code can't be blank") 
            end

            if res["headers"].present?
                isValid = true
                res["headers"].each do | key, value |
                    isValid = (value.instance_of? String)? true : false
                    errors.add(:response, "response headers attributes: #{key} must have value of data type string") if !isValid
                end
            end

            if res["body"].present?
                isValid = true
                isValid = (res["body"].instance_of? String)? true : false
                errors.add(:response, "response body value must be of data type string") if !isValid    
            end
        rescue JSON::ParserError => e
            errors[response.to_s] << "is not valid JSON" 
        end
    end

    # Checks if duplicate verb,path combination endpoint exist for the user
    def endpoint_present?
        endpoint = Endpoint.find_by(user_id: user_id, verb: verb, path: path)
        if  endpoint && (id.present? ? id != endpoint[:id] : true)
            errors.add(:verb, "Endpoint already exist for the combination verb: #{verb} and path: #{path}")
            errors.add(:path, "Endpoint already exist for the combination path: #{path} and verb #{verb}")
        end
    end
end
