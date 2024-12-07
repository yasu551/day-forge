module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?

    attr_reader :current_person_class
  end

  class_methods do
    def authentication_for(current_person_class, new_person_session_url:, person_root_url:)
      @current_person_class = current_person_class
      @new_person_session_url = new_person_session_url
      @person_root_url = person_root_url
    end

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
    current_person_class.send(underscored_session_name) || current_person_class.send("#{underscored_session_name}=", find_session_by_cookie)
  end

  def find_session_by_cookie
    session_class.find_by(id: cookies.signed[:session_id])
  end

  def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to @new_person_session_url
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || @person_root_url
  end

  def start_new_session_for(person)
    sessions = person.send("#{underscored_session_name.pluralize}")
    sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      current_person_class.send("#{underscored_session_name}=", session)
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    current_person_class.send(underscored_session_name).destroy
    cookies.delete(:session_id)
  end

  def session_class
    "#{current_person_class.to_s.delete_prefix("Current")}Session".constantize
  end

  def underscored_session_name
    session_class.name.underscore
  end
end
