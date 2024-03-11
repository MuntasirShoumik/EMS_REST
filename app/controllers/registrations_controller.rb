class RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include RenderApiHelper
  
  def signup
    begin
      manager = Manager.create(user_params)

      if manager.save
        render_api_message("manager created successfully", :created)
      else
        render_api_error(manager.errors, :unprocessable_entity)
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :password, :password_confirmation)
  end
end
