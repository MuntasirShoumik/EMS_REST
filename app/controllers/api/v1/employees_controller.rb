require 'date'
class Api::V1::EmployeesController < ApplicationController
  before_action :require_login
  skip_before_action :verify_authenticity_token
  include JwtHelper
  include RenderApiHelper

  def assigned_tasks

    begin
      task = current_user.tasks.all
      render json: TaskSerializer.new(task), status: :ok
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end

  def update_tsak

    begin
      task = current_user.tasks.find_by(id: params[:id])

      if task.nil?
        render_api_message("task not found", :not_found)
      elsif task.update(task_params)
        render_api_message("updated", :ok)
      else
        render_api_error(task.errors, :unprocessable_entity)
      end 
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end


  def request_leave

    begin
      days =  (Date.parse(request_params[:end_date] ) - Date.parse(request_params[:start_date])).to_i + 1
      if current_user.leave_count.count < days
        render_api_message("you don't have #{days} days remaining leaves", :unprocessable_entity)
      else
        make_request = current_user.leave_requests.create(request_params)
        if make_request.save
          render_api_message("requested", :created)
        else
          render_api_error(make_request.errors, :unprocessable_entity)
        end
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)  
    end

  end

  def requests_status

    begin
      requests = current_user.leave_requests.all
      render json: LeaveRequestSerializer.new(requests), status: :ok
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end
      
  end


  def leave_count

    begin
      count = current_user.leave_count
      render_api_message(count.count, :ok)  
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end
    
  end

  private

  def require_login
    render_api_message('Unauthorized', :unauthorized) unless current_user(Employee)
  end

  def task_params
    params.require(:task).permit(:status )
  end

  def request_params
    params.require(:leave_request).permit(:start_date, :end_date, :reason, :status)
  end
end
