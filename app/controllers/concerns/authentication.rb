require "jwt"

class AuthenticationError < StandardError; end

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
    rescue_from AuthenticationError, with: :handle_authentication_error
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def secret_key_base
      Rails.application.credentials.secret_key_base
    end

    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || unauthorized
    end

    def resume_session
      Current.session ||= find_session_by_jwt
    end

    def find_session_by_jwt
      token = request.headers["Authorization"]&.split(" ")&.last
      return unless token

      payload = JWT.decode(token, secret_key_base, true, { algorithm: "HS256" })
      session = Session.find_by(id: payload[0]["session_id"]) if payload.present?

      unauthorized("Session not found") unless session

      session
    end

    def unauthorized(message = "Unauthorized")
      raise AuthenticationError, message
    end

    def start_new_session_for(user)
      session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
      Current.session = session
      token = encode_jwt(session_id: session.id)
      token
    end

    def terminate_session
      Current.session.destroy
    end

    private

    def secret_key_base
      Rails.application.credentials.secret_key_base
    end

    def encode_jwt(payload)
      JWT.encode(payload, secret_key_base, "HS256")
    end

    def current_user
      @current_user ||= User.find_by(id: Current.session&.user_id)
    end

    def handle_authentication_error(error)
      render json: { error: error.message }, status: :unauthorized
    end
end
