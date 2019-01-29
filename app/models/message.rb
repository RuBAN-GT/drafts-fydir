class Message < ApplicationRecord
  self.per_page = 20

  # relations
  belongs_to :user
  belongs_to :conversation

  # validation
  validates :conversation, :presence => true
  validates :body, :presence => true, :length => { :maximum => 260 }

  validate :only_members

  # scopes
  default_scope do
    order :created_at => :desc, :id => :desc
  end

  after_create_commit do
    reset_view_status
    broadcast_message
    broadcast_conversation
  end

  # reset view status for other conversation members
  def reset_view_status
    members = conversation.conversation_members

    members = members.where.not(:user_id => user.id) unless user.nil?

    members.update_all :viewed => false
  end

  # broadcasting
  def broadcast_message
    MessagesBroadcastJob.perform_later self
  end
  def broadcast_conversation
    conversation.broadcast_save
  end

  def export_hash
    content = {
      :id => id,
      :created_at => created_at.strftime('%Y.%m.%d %H:%M:%S'),
      :updated_at => updated_at.strftime('%Y.%m.%d %H:%M:%S'),
      :body => body,
      :link => Rails.application.routes.url_helpers.widgets_conversation_message_path(conversation, self),
      :user => nil
    }

    content[:user] = {
      :nickname => user.nickname,
      :link => Rails.application.routes.url_helpers.user_path(user),
      :avatar => user.avatar
    } unless user.nil?

    content
  end

  protected

    def only_members
      errors.add :user_id, I18n.t('errors.messages.subscription') unless user.nil? || !conversation.nil? && conversation.has_user?(user)
    end
end
