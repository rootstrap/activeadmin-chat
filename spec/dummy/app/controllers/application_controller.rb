class ApplicationController < ActionController::Base
  helper_method :current_admin_user, :destroy_admin_user_session_path

  def current_admin_user
    @current_admin_user ||= AdminUser.last
  end

  def destroy_admin_user_session_path; end
end
