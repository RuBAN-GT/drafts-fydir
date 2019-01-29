class LookingActivity < ApplicationRecord
  # relations
  has_many :looking_requests

  # scopes
  default_scope {
    order :slug => :asc
  }

  # validations
  validates :slug, :presence => true, :uniqueness => true, :format => { :with => /\A[a-zA-Z0-9_-]+\z/ }

  def name
    I18n.t "activities.#{slug}"
  end
end
