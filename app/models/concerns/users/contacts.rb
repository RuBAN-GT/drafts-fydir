module Users
  module Contacts
    extend ActiveSupport::Concern

    included do
      validates :vkontakte, :contacts => {:domain => 'vk.com', :nickname => true}
      validates :twitter, :contacts => {:domain => 'twitter.com', :nickname => true}
      validates :facebook, :contacts => {:domain => 'facebook.com', :nickname => true}
      validates :telegram, :contacts => {:domain => 'telegram.me',:nickname => true}
      validates :twitch, :contacts => {:domain => 'twitch.tv', :nickname => true}
    end

    def bungie_profile_path
      id = guardian&.get_bungie_account&.bungieNetUser&.membershipId

      "https://www.bungie.net/en/Profile/254/#{id}" unless id.nil?
    end

    def destiny_tracker_path
      "http://destinytracker.com/destiny/overview/#{(guardian&.membership_type == 2) ? 'ps' : 'xbox' }/#{guardian_name}" if guardian_name.present?
    end

    # check if user have any contacts
    def has_contacts?
      vkontakte.present? || twitter.present? || facebook.present? || twitch.present? || telegram.present?
    end
  end
end
