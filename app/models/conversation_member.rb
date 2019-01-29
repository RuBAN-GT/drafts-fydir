class ConversationMember < ApplicationRecord
  # relations
  belongs_to :user
  belongs_to :conversation

  # validations
  validates :conversation, :uniqueness => { :scope => :user }
  validates :user, presence: true
end
