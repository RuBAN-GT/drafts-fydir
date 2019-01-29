module Users
  module Guardian
    extend ActiveSupport::Concern

    included do
      scope :guardian_name, -> (guardian_name) {
        where "lower(guardian_name) LIKE ?", "#{guardian_name.downcase}%" if guardian_name.is_a? String
      }
    end

    # Get guardian api wrapper
    #
    # @return [BungieClient::Wrappers::User]
    def guardian
      return if guardian_name.blank? || email.blank?
      return @guardian unless @guardian.nil?

      begin
        @guardian = BungieClient::Wrappers::User.new(
          :client => RailsClient.new(:prefix => email, :ttl => 3.days),
          :membership_type => membership_type,
          :display_name => guardian_name
        )
      rescue
        nil
      end
    end

    # Check guardian name on existing
    #
    # @return [Boolean]
    def guardian_exists?
      !!guardian&.destiny_membership_id.is_a?(String)
    end

    # Get membership type through platform for bungie api
    def membership_type
      case ((platform.nil?) ? '' : platform.slug.to_s)
        when 'ps4', 'ps3'
          2
        when 'xbox360', 'xboxone'
          1
        else
          254
      end
    end

    # Get guardian profile url in PSN/Live
    def guardian_url
      case platform.slug.to_sym
        when :ps4, :ps3
          "http://psnprofiles.com/#{guardian_name}"
        when :xboxone, :xbox360
          "https://account.xbox.com/en-GB/Profile?GamerTag=#{guardian_name}"
        else
          ''
      end if guardian_name.present?
    end

    # update guardian profile in cache
    def guardian_update
      guardian_update! if allow_update_guardian?
    end
    def guardian_update!
      if self.new_record?
        self.guardian_updated_at = DateTime.now
      else
        self.touch :guardian_updated_at
      end

      guardian&.get_bungie_account({}, {:cached => false})
    end

    # Check on allowing to updating guardian information
    def allow_update_guardian?
      return true if guardian_updated_at.nil?

      guardian_updated_at.utc < (DateTime.now - 30.minutes).utc
    end
  end
end
