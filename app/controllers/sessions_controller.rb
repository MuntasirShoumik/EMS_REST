class SessionsController < ApplicationController
  include JwtHelper
  skip_before_action :verify_authenticity_token
  include RenderApiHelper


  def manager_login

    begin
      manager = Manager.find_by(email: params[:email])

      if !manager.nil? && manager.authenticate(params[:password])
        access_token = encode_access_token(id: manager.id)
        refresh_token = encode_refresh_token(id: manager.id)
  
        render json: {tokens: { access: access_token, refresh: refresh_token } }, status: :ok
      else
        render_api_message("Invalid email or password", :unauthorized)
      end
      
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end



  def employee_login

    begin
      employee = Employee.find_by(email: params[:email])

      if !employee.nil? && employee.authenticate(params[:password])
        access_token = encode_access_token(id: employee.id)
        refresh_token = encode_refresh_token(id: employee.id)
  
        render json: {tokens: { access: access_token, refresh: refresh_token } }, status: :ok
      else
        render_api_message("Invalid email or password", :unauthorized)
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end






  def manager_logout

    if current_user(Manager)
      if blacklist_tokens
        render_api_message("Logged out successfully", :ok)
      else
        render_api_message("Invalid tokens", :unauthorized)
      end
    else
      render_api_message("Login first", :unauthorized)
    end

  end

  def employee_logout

    if current_user(Employee)
      if blacklist_tokens
        render_api_message("Logged out successfully", :ok)
      else
        render_api_message("Invalid tokens", :unauthorized)
      end
    else
      render_api_message("Login first", :unauthorized)
    end

  end



  def refresh_manager_token
    access_token = refresh_access_token(params[:refresh_token], Manager)

    if access_token
      render json: {token: { access: access_token}}, status: :ok
    else
      render_api_message("Invalid or expired refresh token", :unauthorized)
    end
  end

  def refresh_employee_token

    access_token = refresh_access_token(params[:refresh_token], Employee)

    if access_token
      render json: {token: { access: access_token}}, status: :ok
    else
      render_api_message("Invalid or expired refresh token", :unauthorized)
    end

  end


end
