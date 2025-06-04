class ApplicationController < ActionController::Base
  # Uncomment this if you want to disable CSRF protection
  skip_before_action :verify_authenticity_token

  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
