class Conversation < ApplicationRecord
  self.per_page = 10

  class << self
    # find common conversations for users stack
    def contain(*args)
      co = result = joins(:conversation_members)&.distinct

      args.uniq.each do |member|
        if member.is_a? ConversationMember
          id = member.user_id
        elsif member.is_a? User
          id = member.id
        else
          raise 'Wrong argument type: it can be User or ConversationMember'
        end

        tmp = co.where('conversation_members.user_id' => id)

        if tmp.any?
          result = result & tmp
        else
          return []
        end
      end if result.any?

      result.to_a || []
    end

    # find conversation with users stack
    def strong_contain(*args)
      variants = self.contain *args

      variants.uniq.select { |c|
        c.conversation_members.length == args.length
      }.first || nil
    end

    # destroy all conversations without messages
    def destroy_empty
      includes(:messages).where('messages.id' => nil).destroy_all
    end
  end

  # scopes
  scope :actual, ->  {
    includes(:messages).order 'messages.created_at DESC'
  }

  # callbacks
  after_destroy :broadcast_destroy

  # validation
  validate :valid_users?

  # relations
  has_many :conversation_members, :dependent => :destroy
  has_many :users, :through => :conversation_members
  has_many :messages, :dependent => :destroy

  accepts_nested_attributes_for :conversation_members
  accepts_nested_attributes_for :messages

  # form conversation name
  def title(exclude = nil)
    if users.length > 1
      title = users.where.not(:id => exclude).map{ |u| u.nickname }.join ', '
    else
      title = users.first&.nickname
    end

    title[0, 25] + (title.length > 25 ? '...' : '')
  end

  # Check conversation for seen status for user
  def seen?(member)
    conversation_members.where(
      :user_id => member.id,
      :viewed => true
    ).exists?
  end
  # Change view status
  def view(member)
    conversation_members.where(
      :user_id => member.id,
      :viewed => false
    ).update_all :viewed => true

    broadcast_save member
  end

  # get front interlocutor of conversation
  def front_member(exclude = nil)
    if users.length > 1
      users.where.not(:id => exclude).first
    else
      users.first
    end
  end

  # check if conversation has given user
  def has_user?(user)
    conversation_members.where(:user_id => user.id).any?
  end

  # check if conversation has active (parted) user
  def has_active_user?(user)
    conversation_members.where(
      :user_id => user.id,
      :parted => true
    ).any?
  end

  # start conversation for selected users
  def start(*args)
    conversation = self.class.strong_contain(*args)

    if conversation.nil?
      conversation = Conversation.new()

      conversation.join *args

      conversation.save
    end

    conversation
  end

  # abort the users from conversation
  def leave(*args)
    args.each do |user|
      conversation_members.where(:user_id => user.id).update_all :parted => false

      destroy_empty
      broadcast_destroy user
    end
  end

  # join the users to conversation
  def join(*args)
    args.uniq.each do |user|
      conversation_members.where(:user_id => user.id).update_all :parted => true

      conversation_members.build :user_id => user.id rescue nil

      broadcast_save user
    end
  end

  # check conversation on empty status
  def is_empty?
    conversation_members.where(:parted => true).empty?
  end

  def export_hash
    {
      :id => id,
      :created_at => created_at.strftime('%Y.%m.%d %H:%M:%S'),
      :updated_at => updated_at.strftime('%Y.%m.%d %H:%M:%S'),
      :link => Rails.application.routes.url_helpers.widgets_conversation_path(self)
    }
  end

  # destroy conversations without users
  def destroy_empty
    destroy if persisted? && is_empty?
  end

  # broadcasting
  def broadcast_save(user = nil)
    ConversationsBroadcastJob.perform_later self, 'save', user if persisted?
  end
  def broadcast_destroy(user = nil)
    ConversationsBroadcastJob.perform_later self, 'destroy', user if persisted?
  end

  protected

    def valid_users?
      if conversation_members.detect { |m| conversation_members.count(m) > 1}
        errors.add :conversation_members, I18n.t('errors.conversations.repeat_users')
      else
        if conversation_members.length > 6
          errors.add :conversation_members, I18n.t('errors.conversations.many_users')
        elsif conversation_members.length > 1
          ex = self.class.strong_contain(*conversation_members)

          errors.add :conversation_members, I18n.t('errors.conversations.exists') if !ex.nil? && ex.conversation_members.length == conversation_members.length
        else
          errors.add :conversation_members, I18n.t('errors.conversations.little')
        end
      end
    end
end
