module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      set_current_user || reject_unauthorized_connection
    end

    private

    def secret_key_base
      Rails.application.credentials.secret_key_base
    end

    def token_header
      request.query_parameters["token"]
    end

    def find_session_by_jwt
      token = token_header
      return unless token

      payload = JWT.decode(token, secret_key_base, true, { algorithm: "HS256" })
      Session.find_by(id: payload[0]["session_id"]) if payload.present?
    end

    def set_current_user
      if session = Session.find_by(id: cookies.signed[:session_id])
        self.current_user = session.user
      end
    end
  end
end
