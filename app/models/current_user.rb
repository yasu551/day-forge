class CurrentUser < ActiveSupport::CurrentAttributes
  include Current

  current_for User
end
