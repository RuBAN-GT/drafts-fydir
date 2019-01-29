api_response.builder json do
  json.partial! '/api/v1/messages/shared/message', :message => @message
end
