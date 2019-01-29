api_response.builder json do
  json.partial! '/api/v1/conversations/shared/conversation', :conversation => @conversation
end
