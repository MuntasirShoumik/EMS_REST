class PasswordsController < ApplicationController
  include JwtHelper
  skip_before_action :verify_authenticity_token
  include RenderApiHelper


  def emp_password_reset
    current_user(Employee)
    if !current_user.nil? && current_user.authenticate(params[:current_password])
      if current_user.update(password_params)
        blacklist_tokens
        render_api_message("password updated", :ok)
      else
        render_api_error(current_user.errors, :unauthorized)
      end
    else
      render_api_message("Invalid password", :unauthorized)
    end
  end

  def manager_password_reset
    current_user(Manager)
    if !current_user.nil? && current_user.authenticate(params[:current_password])
      if current_user.update(password_params)
        blacklist_tokens
        render_api_message("password updated", :ok)
      else
        render_api_error(current_user.errors, :unauthorized)
      end
    else
      render_api_message("Invalid password", :unauthorized)
    end
  end
    
    
  private

  def password_params
    params.require(:update).permit(:password, :password_confirmation)
  end
end
