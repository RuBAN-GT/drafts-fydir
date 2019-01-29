module Users
  module GuardianName
    extend ActiveSupport::Concern

    class_methods do
      # Check the input nick on free in database
      def guardian_name_free?(name)
        where("guardian_name = ? AND guardian_token_confirmed_at is not null", name).empty?
      end
    end

    included do
      after_initialize :generate_guardian_token, :if => :new_record?

      before_save :guardian_reset_verification

      validates :guardian_token, presence: true

      validate :valid_guardian_name?
    end

    # Update guardian token
    def generate_guardian_token
      self.guardian_token = random_hex
    end

    # Update verification status after successful checking of status
    def guardian_verify
      guardian_with_correct_status? ? guardian_verify! : false
    end

    # Mark verification status without checking
    def guardian_verify!
      return false if guardian_name.blank?

      if self.new_record?
        self.guardian_token_confirmed_at = DateTime.now
      else
        self.touch :guardian_token_confirmed_at
      end

      self.class.where('id != ? AND guardian_name = ?', id, guardian_name).update_all :guardian_name => nil

      true
    end

    def guardian_unlink
      self.guardian_token_confirmed_at = nil

      generate_guardian_token
    end

    # check equaling of guardian token and status
    def guardian_with_correct_status?
      return true if guardian_verified?
      return false if guardian_token.nil?

      guardian_token == self.guardian&.get_bungie_account({}, {:cached => false})&.bungieNetUser&.statusText
    end

    # check verification status
    def guardian_verified?
      !guardian_token_confirmed_at.nil?
    end

    protected

      def valid_guardian_name?
        if platform.nil?
          errors.add :guardian_name, I18n.t('errors.users.guardian.platform')
        elsif email.nil?
          errors.add :guardian_name, I18n.t('errors.users.guardian.email')
        elsif guardian_name != guardian_name_was && !self.class.guardian_name_free?(guardian_name)
          errors.add :guardian_name, I18n.t('errors.users.guardian.used')
        elsif !guardian_exists?
          errors.add :guardian_name, I18n.t('errors.users.guardian.wrong')
        end if guardian_name.present?
      end

      def guardian_reset_verification
        guardian_unlink if !guardian_name_was.blank? && guardian_name_was != guardian_name
      end

      def random_hex
        SecureRandom.hex(3)
      end
  end
end
