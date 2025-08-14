class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout "vertical"

  #before_action :require_login
  helper_method :current_user


  private

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session&.record
  end

  def require_login
    unless current_user
      redirect_to login_path
    end
  end
end
