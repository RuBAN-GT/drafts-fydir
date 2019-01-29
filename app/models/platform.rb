class Platform < ApplicationRecord
  # relations
  has_many :users
  has_many :looking_requests

  # validations
  validates :name, :presence => true, :uniqueness => true
  validates :slug, :presence => true, :uniqueness => true, :format => { :with => /\A[a-zA-Z0-9_-]+\z/ }
end
