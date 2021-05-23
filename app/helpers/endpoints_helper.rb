module EndpointsHelper
    def construct_endpoints_response (endpoints)
        formattedEndpoints = []
        endpoints.each { |endpoint|
          formattedEndpoints.push(
            construct_endpoint_response(endpoint)
          )
        }
        formattedEndpoints 
      end
  
      def construct_endpoint_response(endpoint)
        {
          "type": "endpoints",
          "id": endpoint[:id],
          "attributes": {
            "verb": endpoint[:verb],
            "path": endpoint[:path],
            "response": JSON.parse(endpoint[:response])
            }
        }
      end
  
      def get_endpoint_params (endpoint_params)
        {
          :verb => endpoint_params.dig(:data, :attributes, :verb), 
          :path => endpoint_params.dig(:data, :attributes, :path),
          :response => endpoint_params.dig(:data, :attributes, :response)?  endpoint_params.dig(:data, :attributes, :response).to_json : nil
        }
      end
  end
  