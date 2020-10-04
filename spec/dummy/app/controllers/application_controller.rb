class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    AdminUser.first
  end
end
