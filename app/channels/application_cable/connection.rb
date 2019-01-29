module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

      def find_verified_user
        return env['warden'].user

        if verified_user.nil?
          reject_unauthorized_connection
        else
          verified_user
        end
      end
  end
end
