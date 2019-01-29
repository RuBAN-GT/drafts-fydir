class User < ApplicationRecord
  include Users::Ratio
  include Users::Guardian
  include Users::GuardianName
  include Users::Contacts
  include Filterable

  # scopes
  default_scope {
    order :created_at => :desc
  }

  scope :nickname, -> (nickname) { where "lower(nickname) LIKE ?", "#{nickname.downcase}%" if nickname.is_a? String }
  scope :platform, -> (platform_slug) {
    p = Platform.find_by_slug platform_slug

    where :platform_id => p.id unless p.nil?
  }

  # devise
  acts_as_token_authenticatable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    # :confirmable,
    # :omniauthable,
    :lockable

  # relations
  has_and_belongs_to_many :roles, :join_table => :users_roles, :dependent => :destroy
  has_many :looking_requests, :dependent => :destroy
  has_many :conversation_members, :dependent => :destroy
  has_many :conversations, :through => :conversation_members, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  belongs_to :platform

  # validations
  validates :realname, presence: true, length: { minimum: 2, maximum: 50 }
  validates :nickname, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_-]{3,25}\z/ }, exclusion: { in: %w(search,admin,ruban,fydir) }
  validates :motto, length: { :maximum =>  100 }
  validates :about, length: { :maximum =>  400 }

  # for router
  def to_param
    nickname
  end

  # Check role
  #
  # @param [String|Symbol] role
  # @return [Boolean]
  def role?(role)
    !roles.find_by_slug(role.to_s).nil?
  end

  # Checking user for online
  def online?
    !!Rails.cache.read("online.#{id}")
  end

  # Get count of unseen conversations
  def unseen_count
    conversation_members.where(:viewed => false, :parted => true).count
  end

  # Show user gravatar
  #
  # @param [Integer] size = 200 describe size = 200
  # @param [String|Symbol] type = :identicon
  # @return [String] url to gravatar
  def gravatar(size = 200, type = :identicon)
    if email.blank?
      "//s.gravatar.com/avatar/00000000000000000000000000000000?s=#{size}&d=#{type}"
    else
      "//s.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=#{size}&d=#{type}"
    end
  end
  def avatar
    if File.exists? "#{Rails.root}/public/images/avatars/#{email}.png"
      return "/images/avatars/#{email}.png"
    elsif !@avatar.nil?
      return @avatar
    end

    @avatar = guardian&.get_bungie_account&.bungieNetUser&.profilePicturePath

    if @avatar.nil?
      @avatar = gravatar 180 if @avatar.nil?
    else
      @avatar = 'https://www.bungie.net' + @avatar
    end
  end
end
