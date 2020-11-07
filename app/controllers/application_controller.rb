class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  before_action :oathy_confirmation

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone])
  end

  private

  def oathy_confirmation
    if user_signed_in? && current_user.authy_hook_enabled && current_user.last_sign_in_with_authy
      current_user.authy_hook_turn_off
    end
  end
end
