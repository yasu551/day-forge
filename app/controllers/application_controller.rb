class ApplicationController < ActionController::Base
  include Authentication

  authentication_for User, new_person_session_url: :new_user_session_url, person_root_url: :root_url
  allow_browser versions: :modern
end
