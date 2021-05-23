class Endpoint < ApplicationRecord
    validates_presence_of :verb, :path, :response, :user_id, presence: true
    validates_presence_of :user_id, presence: false, on: :update
    
    validates :verb, :inclusion => { :in => %w(GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE PATCH), 
        :message => "%{value} is not a valid HTTP Method" },  :if => :verb?
    validates :path, format: { with: /\// ,  message: "Path attribute needs to start with /" }
    validate :validate_endpoint_response
    validate :endpoint_present? , on: [:create, :update]

    belongs_to :user

    private

    def validate_endpoint_response
        begin
            return if response.nil?
            res = JSON.parse(response)
            isValid = true
            if !res["code"].is_a? Integer
                if res["code"].present?
                    errors.add(:response, 'response code must have value of data type integer') 
                else
                    errors.add(:response, 'response code is mandatory field') 
                end
            elsif res["headers"].present?
                header_attributes = []
                res["headers"].each do | key, value |
                    isValid = (value.instance_of? String)? true : false
                    header_attributes.push(key) if !isValid
                end
                header_attributes = header_attributes.join(",")
                errors.add(:response, "response headers attributes: < #{header_attributes} > must have value of data type string") if !isValid                    
            end
        rescue JSON::ParserError => e
            errors[response.to_s] << "is not valid JSON" 
        end
    end

    def endpoint_present?
        endpoint = Endpoint.find_by(user_id: user_id, verb: verb, path: path)
        if  endpoint && (id.present? ? id != endpoint[:id] : true)
            errors[:verb] << "Endpoint already exist for this verb: #{verb} and path: #{path}"
            errors[:path] << "Endpoint already exist for this path: #{path} and verb #{verb}"
        end
    end
end
