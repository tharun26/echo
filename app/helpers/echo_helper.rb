module EchoHelper
    def prepare_response (endpoint)
        endpoint_response = endpoint[:response]
        endpoint_response = JSON.parse(endpoint_response)
        
        endpoint_response_body = endpoint_response["body"]
        endpoint_response_headers = endpoint_response["headers"]
        (endpoint_response_body.sub!(/^\"/, "") && endpoint_response_body.sub!(/\"$/, "")) if endpoint_response_body
        endpoint_response_body = endpoint_response_body ? endpoint_response_body : ''
        set_header(endpoint_response_headers) if endpoint_response_headers
        return endpoint_response_body, endpoint_response["code"]
      end

    def set_header (headers)
        headers.each do | key, value |
            response.set_header(key, value)
        end
    end
end
  