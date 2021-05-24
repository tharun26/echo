module EchoHelper
    def prepare_response (endpoint)
        endpoint_response = endpoint[:response]
        endpoint_response = JSON.parse(endpoint_response)
        
        endpoint_response_body = endpoint_response["body"]
        endpoint_response_headers = endpoint_response["headers"]
        (endpoint_response_body.sub!(/^\"/, "") && endpoint_response_body.sub!(/\"$/, "")) if endpoint_response_body
        endpoint_response_body = endpoint_response_body ? endpoint_response_body : ''
        #print(response.headers)
        #delete_headers
        set_header(endpoint_response_headers) if endpoint_response_headers
        #print(response.headers)
        return endpoint_response_body, endpoint_response["code"]
      end

    def delete_headers
        headers = response.headers
        headers.each do | key, value |
            response.delete_header(key)
        end
    end

    def set_header (headers)
        headers.each do | key, value |
            response.set_header(key, value)
        end
    end
end
  