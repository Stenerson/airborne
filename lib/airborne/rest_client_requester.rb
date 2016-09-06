require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = base_headers.merge(options[:headers] || {})
      res = if method == :post || method == :patch || method == :put || method == :delete
        begin
          request_body = options[:body].nil? ? '' : options[:body]
          request_body = request_body.to_json if options[:body].is_a?(Hash)
          if method == :delete
            RestClient::Request.execute(method: method, url: get_url(url), payload: request_body, headers: headers)
          else
            RestClient.send(method, get_url(url), request_body, headers)
          end
        rescue RestClient::Exception => e
          e.response
        end
      else
        begin
          RestClient.send(method, get_url(url), headers)
        rescue RestClient::Exception => e
          e.response
        end
      end
      res
    end

    private

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end
  end
end
