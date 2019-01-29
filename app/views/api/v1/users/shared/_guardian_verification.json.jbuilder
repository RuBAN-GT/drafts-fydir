json.guardian_name user.guardian_name
json.guardian_verified user.guardian_verified?
json.guardian_token (is_current?(user) ? user.guardian_token : nil)
json.guardian_updated_at user.guardian_updated_at
