api_response.builder json do
  json.ratio @user.ratio
  json.voted_ratio @user.voted_ratio(current_user) if user_signed_in?
end
