class UserRatio < ApplicationRecord
  self.table_name = :users_ratios

  # relations
  belongs_to :user
  belongs_to :voted, :class_name => 'User'

  # validations
  validates :user, presence: true, :uniqueness => { :scope => :voted }
  validates :voted, presence: true
  validates :point, presence: true, :inclusion => 1..5

  validate :unique_vote

  protected

    def unique_vote
      errors.add :user_id, 'Нельзя ставить рейтинг самому себе' if user_id == voted_id
    end
end
