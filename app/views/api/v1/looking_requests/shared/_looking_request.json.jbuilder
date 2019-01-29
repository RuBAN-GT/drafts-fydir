json.id looking_request.id

json.created_at looking_request.created_at
json.updated_at looking_request.updated_at

json.link (looking_request.new_record? ? nil : looking_request_path(looking_request))

json.title looking_request.title
json.looking_activity looking_request.looking_activity&.slug
json.platform looking_request.platform&.slug
json.description looking_request.description

json.user looking_request.user.nickname

json.looking_type looking_request.looking_type
json.experience looking_request.experience
json.min_light looking_request.min_light
json.microphone looking_request.microphone
