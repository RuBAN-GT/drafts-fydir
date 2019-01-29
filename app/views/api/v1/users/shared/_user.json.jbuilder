json.email (is_current?(user) ? user.email : nil)

json.authentication_token (is_current?(user) ? user.authentication_token : nil)

json.created_at user.created_at
json.updated_at user.updated_at
json.last_active_at user.last_active_at

json.link user_path(user)

json.realname user.realname
json.nickname user.nickname
json.motto user.motto
json.about user.about
json.platform user.platform&.slug

json.avatar user.avatar

json.partial! '/api/v1/users/shared/guardian_verification', :user => user

json.guardian_url user.guardian_url
json.bungie_url user.bungie_profile_path
json.destiny_tracker_url user.destiny_tracker_path

json.vkontakte user.vkontakte
json.twitter user.twitter
json.facebook user.facebook
json.telegram user.telegram
json.twitch user.twitch
