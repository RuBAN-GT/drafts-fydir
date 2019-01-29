json.id conversation.id

json.created_at conversation.created_at
json.updated_at conversation.updated_at

json.link (conversation.new_record? ? nil : widgets_conversation_path(conversation))

json.messages conversation.messages.count

json.seen conversation.seen?(current_user)

json.conversation_members do
  json.array! conversation.conversation_members do |member|
    json.nickname member.user.nickname
    json.parted member.parted

    json.created_at member.created_at
    json.updated_at member.updated_at
  end
end
