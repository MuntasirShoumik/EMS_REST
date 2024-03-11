class Api::V1::ManagersController < ApplicationController
  before_action :require_login
  skip_before_action :verify_authenticity_token
  include JwtHelper
  include RenderApiHelper



  def index

    begin
      emp = current_user.employees.all
      render json: EmployeeSerializer.new(emp), status: :ok
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end


  def create_emp

    begin
      emp = current_user.employees.create(emp_params)
      leave_count = emp.build_leave_count(count: 10) 
      if emp.save
        render_api_message("employee created", :created)
      else
        render_api_error(emp.errors, :unprocessable_entity)
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end
    
  end


  def update_emp

    begin
      emp = current_user.employees.find(params[:id])
      if emp.nil?
        render_api_message("employees not found", :not_found)
      elsif emp.update(emp_params)
        render_api_message("updated", :accepted)
      else
        render_api_error(emp.errors, :unprocessable_entity)
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end


  def destroy_emp

    begin
      emp = current_user.employees.find_by(id: params[:id])
      if emp.nil?
        render_api_message("employees not found", :not_found)
      elsif emp.destroy
        render_api_message("Deleted", :ok)
      else
        render_api_message("Could not Deleted", :internal_server_error)
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end    

  end


  def search_emp

    begin
      emp = current_user.employees.find_by(id: params[:id])
      if emp
        render json: EmployeeSerializer.new(emp), status: :ok
      else
        render_api_message("Could not Find contact", :internal_server_error)
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end
    
  end


  def set_task

    begin
      task = current_user.employees.find_by(id: params[:id]).tasks.create(task_param)
      if task.save
        render_api_message("task created", :created)
      else
        render_api_error(task.errors, :unprocessable_entity)
      end     
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end

  def get_task

    begin
      emp_under = current_user.employees
      task = Task.where(employee_id: emp_under.pluck(:id))
      render json: TaskSerializer.new(task), status: :ok
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end

  def view_requests

    begin
      emp_under = current_user.employees
      requests = LeaveRequest.where(employee_id: emp_under.pluck(:id))
      render json: LeaveRequestSerializer.new(requests), status: :ok
    rescue => e
      render_api_error(e.message, :internal_server_error)
    end

  end

  def update_request

    begin
      emp_under = current_user.employees
      requests = LeaveRequest.where(employee_id: emp_under.pluck(:id))
      request_to_update = requests.find_by(id: params[:id])
      


      if request_to_update.nil?
        render_api_message("not found", :not_found)

      elsif request_to_update.update(request_params)

        days = (request_to_update.end_date - request_to_update.start_date).to_i + 1
        count_to_update = LeaveCount.find_by(employee_id: request_to_update.employee_id )
        if request_params[:status] == "aproved"
          count_to_update.update(count: count_to_update.count - days)
        end
        render_api_message("updated", :ok)

      else
        render_api_message("can not be updated", :internal_server_error)
   
      end
    rescue => e
      render_api_error(e.message, :internal_server_error)

    end


  end

  private

  def emp_params
    params.require(:employee).permit(:name, :email, :phone, :position, :dept, :password, :password_confirmation)
  end

  
  def require_login
    render_api_message('Unauthorized', :unauthorized) unless current_user(Manager)

  end


  def task_param
    params.require(:task).permit(:title, :description, :deadline, :status )
  end

  def request_params
    params.require(:leave_request).permit(:status)
  end



end
