module ApiAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def authenticated?
    resume_session
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    Current.session ||= find_session_by_token
  end

  def find_session_by_token
    Session.find_by(token: request_token)
  end

  def request_token
    request.headers[:token]
  end

  def request_authentication
    render json: { error: "Authentication required" }, status: :unauthenticated
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session
    end
  end

  def terminate_session
    Current.session.destroy
  end
end
