class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    if user_signed_in?
	    puts("WelcomeController.authy_hook_enabled=#{current_user.authy_hook_enabled.inspect}")
	    puts("WelcomeController.authy_enabled=#{current_user.authy_enabled.inspect}")
    end
	if user_signed_in? && current_user.authy_hook_enabled && !current_user.authy_id && !current_user.last_sign_in_with_authy
		redirect_to user_enable_authy_path
	elsif user_signed_in? && current_user.authy_hook_enabled && current_user.authy_id && !current_user.last_sign_in_with_authy
		redirect_to user_verify_authy_installation_path
	end
  end

  def guide
  end
end
