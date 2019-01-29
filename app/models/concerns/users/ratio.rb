module Users
  module Ratio
    extend ActiveSupport::Concern

    included do
      has_many :user_ratios, :join_table => :users_ratios, :dependent => :destroy
    end

    # Get middle ratio
    def ratio
      user_ratios&.average(:point).to_i || 0
    end

    # Ratio for voted user
    def voted_ratio(voted)
      user_ratios.where(:voted_id => voted.id)&.sum(:point) || 0
    end

    # Add point to user
    def vote(point, voted)
      r = user_ratios.where(:voted_id => voted.id).first_or_initialize

      r.point = point.to_i

      r.save
    end
  end
end
