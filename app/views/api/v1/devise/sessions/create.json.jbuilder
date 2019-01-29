api_response.response = @user.authentication_token unless @user.nil?
api_response.builder json
