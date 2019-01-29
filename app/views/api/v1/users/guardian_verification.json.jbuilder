api_response.builder json do
  json.partial! '/api/v1/users/shared/guardian_verification', :user => @user
end
