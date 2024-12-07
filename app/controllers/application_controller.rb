class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern
  authentication_for CurrentUser, new_person_session_url: :new_user_session_url, person_root_url: :root_url
end
