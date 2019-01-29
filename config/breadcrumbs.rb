crumb :root do
  link I18n.t('template.home'), root_path
end

# devise
crumb :sign_in do
  link I18n.t('actions.sign_in'), new_user_session_path

  parent :root
end
crumb :sign_up do
  link I18n.t('actions.sign_up'), new_user_registration_path

  parent :sign_in
end
crumb :new_password do
  link I18n.t('meta_tags.passwords.new.title'), new_user_password_path

  parent :sign_in
end
crumb :edit_password do
  link I18n.t('meta_tags.passwords.edit.title'), edit_user_password_path

  parent :sign_in
end
crumb :new_confirmation do
  link I18n.t('devise.shared.links.didn_t_receive_confirmation_instructions'), new_user_password_path

  parent :sign_in
end
crumb :new_unlock do
  link I18n.t('devise.shared.links.didn_t_receive_unlock_instruction'), new_unlock_path

  parent :sign_in
end

# users
crumb :users do
  link I18n.t('meta_tags.users.defaults.title'), users_path

  parent :root
end
crumb :user do |user|
  link user.nickname, user

  parent :users
end
crumb :edit_user do |user|
  link I18n.t('meta_tags.users.edit.title'), edit_user_path(user)

  parent :user, user
end
crumb :guardian_verification do |user|
  link I18n.t('meta_tags.users.guardian_verification.title'), user_guardian_verification_path(user)

  parent :user, user
end
crumb :user_account_settings do |user|
  link I18n.t('meta_tags.registrations.edit.title'), edit_user_registration_path(user)

  parent :user, user
end

# looking requests
crumb :looking_requests do
  link I18n.t('meta_tags.looking_requests.defaults.title'), looking_requests_path

  parent :root
end
crumb :looking_request do |l|
  link l.title, l

  parent :looking_requests
end
