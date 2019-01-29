api_response.builder json do
  json.partial! '/api/v1/users/shared/user', :user => @user
end
