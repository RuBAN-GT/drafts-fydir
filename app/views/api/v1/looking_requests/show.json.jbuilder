api_response.builder json do
  json.partial! '/api/v1/looking_requests/shared/looking_request', :looking_request => @looking_request
end
