class LookingRequest < ApplicationRecord
  include Filterable

  self.per_page = 10

  class << self

    def looking_type_name(type)
      I18n.t "params.looking_requests.looking_type.types.#{type || 'all'}"
    end

    def experience_name(type)
      I18n.t "params.looking_requests.experience.types.#{type || 'every'}"
    end
  end

  # scopes
  default_scope {
    order :created_at => :desc
  }
  scope :platform, -> (platform_slug) {
    p = Platform.find_by_slug platform_slug

    where :platform_id => p.id unless p.nil?
  }
  scope :looking_activity, -> (activity_slug) {
    a = LookingActivity.find_by_slug activity_slug

    where :looking_activity_id => a.id unless a.nil?
  }
  scope :looking_type, -> (type) {
    where :looking_type => type if %w(group member).include? type
  }
  scope :min_light, -> (light) {
    where 'min_light >= ?', light if (0..400).include? light.to_i
  }
  scope :microphone, -> (microphone) {
    where :microphone => ((microphone == '1' || microphone == 'true') ? true : false)
  }
  scope :experience, -> (exp) {
    where :experience => exp if %w(sherpa novice).include? exp
  }
  scope :user, -> (nickname) {
    user = User.find_by_nickname(nickname)

    where :user_id => user.id unless user.nil?
  }

  # relations
  belongs_to :user
  belongs_to :platform
  belongs_to :looking_activity

  # validations
  validates :description, :length => {:maximum => 260}
  validates :user, :presence => true
  validates :platform, :presence => true
  validates :looking_type, :presence => true, :inclusion => { :in => %w(group member) }
  validates :experience, :inclusion => { :in => %w(every sherpa novice) }
  validates :min_light, :inclusion => 0..400, :unless => 'min_light.nil?'

  # callbacks
  after_create_commit :broadcast_create
  after_update_commit :broadcast_update
  after_destroy :broadcast_destroy

  # methods
  def title
    looking_activity&.name || I18n.t('template.looking_activities.every')
  end

  def looking_type_name
    self.class.looking_type_name looking_type
  end
  def experience_name
    self.class.experience_name experience
  end

  # broadcasting
  def broadcast_create
    LookingRequestsBroadcastJob.perform_later self, 'save'
  end
  def broadcast_update
    LookingRequestsBroadcastJob.perform_later self, 'save'
  end
  def broadcast_destroy
    LookingRequestsBroadcastJob.perform_later self, 'destroy'
  end
end
