require 'rails_helper'

RSpec.describe "Api::V1::Employees", type: :request do
  include FactoryBot::Syntax::Methods
  before do
    manager = create(:manager)
    employee = create(:employee, manager_id: manager.id)
    @task1 = create(:task, employee_id: employee.id)
    @task2 = create(:task, employee_id: employee.id)

    @leave_req = create(:leave_request, employee_id: employee.id)
    @leave_req1 = create(:leave_request, employee_id: employee.id)
    @leave_count = create(:leave_count, employee_id: employee.id)
    

    @access_token = login(employee)
    
  end


  describe "GET /api/v1/assigned_tasks" do
    
    context "when employee want to view assigned tasks" do
      
      it "should return a list of 2 tasks" do
            
        get "http://127.0.0.1:3000/api/v1/assigned_tasks", headers: { "Authorization": @access_token }

        count = JSON.parse(response.body)['data'].length

   
        expect(count).to eq(2)

      end


    end
  end

  describe "POST /api/v1/req_leave" do
    context "When Employees make leave request" do


    it "should return status code created if employee make a leave request" do
        post "http://127.0.0.1:3000/api/v1/req_leave", headers: { "Authorization": @access_token }, params: {
            "leave_request":{
                "start_date": "2023-11-13",
                "end_date": "2023-11-16",
                "reason": @leave_req.reason,
                "status": "Panding"
            }
        }

        expect(response).to have_http_status(:created) 
        # expect(JSON.parse(response.body)["error"]).to eq(" ")
    end

    it "Should return must be in the format YYYY-MM-DD whith status code unprocessable_entity" do
      post "http://127.0.0.1:3000/api/v1/req_leave", headers: { "Authorization": @access_token }, params: {
        "leave_request":{
            "start_date": "9-2023",
            "end_date": @leave_req.end_date,
            "reason": @leave_req.reason,
            "status": @leave_req.status
        }
    }

    expect(JSON.parse(response.body)["errors"]["details"][0]).to eq("invalid date")
    expect(response).to have_http_status(:internal_server_error)  
    end

    it "Should return starting date can not be equal or grater then ending date with status code unprocessable_entity" do
      post "http://127.0.0.1:3000/api/v1/req_leave", headers: { "Authorization": @access_token }, params: {
        "leave_request":{
            "start_date": "2023-11-13",
            "end_date": "2023-10-13",
            "reason": @leave_req.reason,
            "status": @leave_req.status
        }
    }

    expect(JSON.parse(response.body)["errors"]["details"][0]["deadline"][0]).to eq("starting date can not be equal or grater then ending date ")
    expect(response).to have_http_status(:unprocessable_entity)  
    end

    end
    
  end

  describe "get /api/v1/requests_status" do
    context "When employees want to view leave request status" do

      it "should return a list of 2 leave request made by the employee with status code ok" do
        get "http://127.0.0.1:3000/api/v1/requests_status", headers: { "Authorization": @access_token }
        count = JSON.parse(response.body)['data'].length
  
        expect(count).to eq(2)
        expect(response).to have_http_status(:ok)  
  
      end
      
    end
    
  end


  describe "PATCH /api/v1/update_tsak/:id" do

    context "When employees make an update on assign task" do


      it "should return status code ok if updated" do
        patch "http://127.0.0.1:3000/api/v1/update_tsak/#{@task1.id}", headers: { "Authorization": @access_token }, params: {
            "task":{
                "status": "done"
            }
        }
  
        expect(response).to have_http_status(:ok)
      end
    end
    
  end

  describe "GET http://127.0.0.1:3000/api/v1/leave_count" do
    context "When employee views remaining leaves" do
      it "should return 10 days" do
        get "http://127.0.0.1:3000/api/v1/leave_count", headers: { "Authorization": @access_token }
        count = JSON.parse(response.body)["message"]
  
        expect(count).to eq(10)
      end
      
      
    end
    
    
  end
  
  
  
  
  private

  def login(employee)

      post "http://127.0.0.1:3000/emp_login", params: {
              
              
          "email": employee.email,
          "password": employee.password
      }
    
      @access_token = JSON.parse(response.body)['tokens']['access']

  end
end
