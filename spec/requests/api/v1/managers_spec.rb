require 'rails_helper'

RSpec.describe "Api::V1::Managers", type: :request do

  include FactoryBot::Syntax::Methods
  before do
    manager = create(:manager)
    @employee1 = create(:employee, manager_id: manager.id)
    @employee2 = create(:employee, manager_id: manager.id)
    @employee3 = create(:employee, manager_id: manager.id)
    @leave_req = create(:leave_request, employee_id: @employee1.id)
    @task1 = create(:task, employee_id: @employee1.id)
    @task2= create(:task, employee_id: @employee1.id)
    @task3 = create(:task, employee_id: @employee1.id)

    @access_token = login(manager)
  end

  describe "GET /api/v1/all_emp" do
    context "when Manager view all employees" do
      it "should return a list of 3 employees" do
        get "http://127.0.0.1:3000/api/v1/all_emp", headers: { "Authorization": @access_token }
        count = JSON.parse(response.body)['data'].length
        expect(count).to eq(3)
      end
    end
  end

  describe "POST /api/v1/create_emp" do
    context "When manager create employees" do
      it "should return status created" do
            

        post "http://127.0.0.1:3000/api/v1/create_emp",headers: { "Authorization": @access_token } , params: {

            "employee":{
            "name": @employee1.name,
            "email": "test@gmail.com",
            "phone": @employee1.phone,
            "position": @employee1.position,
            "dept": @employee1.dept,
            "password": @employee1.password,
            "password_confirmation": @employee1.password_confirmation
            }
        
        }

        expect(response).to have_http_status(:created)
      end

      
        it "should return calidation errors whith status unprocessable_entity" do
          post "http://127.0.0.1:3000/api/v1/create_emp",headers: { "Authorization": @access_token } , params: {

            "employee":{
              "name": @employee1.name,
              "email": "test",
              "phone": "323dd3232",
              "position": @employee1.position,
              "dept": @employee1.dept,
              "password": "1111",
              "password_confirmation": "2222"
          }
    
        }
        expect(JSON.parse(response.body)["errors"]["details"][0]["email"][0]).to eq("Enter vaid email.")
        expect(JSON.parse(response.body)["errors"]["details"][0]["phone"][0]).to eq("is not a number")
        expect(JSON.parse(response.body)["errors"]["details"][0]["password_confirmation"][0]).to eq("doesn't match Password")
        expect(response).to have_http_status(:unprocessable_entity)
     end
    end
  end


  describe "PATCH api/v1/update_emp/:id" do
    context "When Manager updates employee" do
      it "should return updated with status code accepted" do
        patch "http://127.0.0.1:3000/api/v1/update_emp/#{@employee1.id}",headers: { "Authorization": @access_token } , params: {

          "employee":{
            "name": "updated",
            "email": @employee1.email,
            "phone": @employee1.phone,
            "position": @employee1.position,
            "dept": @employee1.dept,
            "password": @employee1.password,
            "password_confirmation": @employee1.password_confirmation
          }
      
      }

      expect(JSON.parse(response.body)["message"]).to eq("updated")
      expect(response).to have_http_status(:accepted)

      end  
    end
  end

  describe "DELETE /api/v1/destroy_emp/:id" do
    context "When manager deletes employees" do
      it "should return Deleted with status code ok" do
        delete "http://127.0.0.1:3000/api/v1/destroy_emp/#{@employee2.id}", headers: { "Authorization": @access_token }
        expect(JSON.parse(response.body)["message"]).to eq("Deleted")
        expect(response).to have_http_status(:ok)
      end

      it "should return employees not found with status code not_found" do
        delete 'http://127.0.0.1:3000/api/v1/destroy_emp/1123', headers: { "Authorization": @access_token }
        expect(JSON.parse(response.body)["message"]).to eq("employees not found")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /api/v1/employee/:id" do
    context "When manager search employees" do
      it "returns status code ok" do
        get "http://127.0.0.1:3000/api/v1/employee/#{@employee1.id}", headers: { "Authorization": @access_token }

        expect(response).to have_http_status(:ok)
    end

      it "returns status code ok" do
        get "http://127.0.0.1:3000/api/v1/employee/1102", headers: { "Authorization": @access_token }

        expect(JSON.parse(response.body)["message"]).to eq("Could not Find contact")
        expect(response).to have_http_status(:internal_server_error)
      end  
    end 
  end

  describe "POST /api/v1/set_task/:id" do
    context "When manager set task for an employee" do
      it "should return task created with status code created" do
        post "http://127.0.0.1:3000/api/v1/set_task/#{@employee1.id}" , headers: { "Authorization": @access_token }, params: {
          "task":{
              "title": @task1.title, 
              "description": @task1.description,
              "deadline": @task1.deadline,
              "status": @task1.status
          }
      }
      expect(JSON.parse(response.body)["message"]).to eq("task created")
      expect(response).to have_http_status(:created)
      end


      it "should return validation errors with status code unprocessable_entity" do
        post "http://127.0.0.1:3000/api/v1/set_task/#{@employee1.id}" , headers: { "Authorization": @access_token }, params: {
          "task":{
              "title": "", 
              "description": @task1.description,
              "deadline": "2023-6",
              "status": @task1.status
          }
      }
      expect(JSON.parse(response.body)["errors"]["details"][0]["title"][0]).to eq("can't be blank")
      expect(JSON.parse(response.body)["errors"]["details"][0]["deadline"][0]).to eq("must be in the format YYYY-MM-DD")
      expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return status code internal_server_error" do
        post "http://127.0.0.1:3000/api/v1/set_task/12232" , headers: { "Authorization": @access_token }, params: {
          "task":{
              "title": @task1.title, 
              "description": @task1.description,
              "deadline": @task1.deadline,
              "status": @task1.status
          }
      }
   
      expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "GET /api/v1/get_task" do
    context "When manager view all assign tasks" do
      it "should return a list of 3 tasks and status code ok" do
        get "http://127.0.0.1:3000/api/v1/get_task",  headers: { "Authorization": @access_token }
        count = JSON.parse(response.body)['data'].length

        expect(count).to eq(3)
        expect(response).to have_http_status(:ok)
        
      end
    end
  end

  describe "GET /api/v1/view_requests" do
    context "When manager view all leave requests" do
      it "should return 1 request" do
        get "http://127.0.0.1:3000/api/v1/view_requests",  headers: { "Authorization": @access_token }
        count = JSON.parse(response.body).length

        expect(count).to eq(1)
      end
    end
  end

  describe "POST /api/v1/update_request/:id" do
    context "When manager updates a leave request" do
      it "should return updated with status code ok" do
        post "http://127.0.0.1:3000/api/v1/update_request/#{@leave_req.id}",  headers: { "Authorization": @access_token }, params:
        {
            "leave_request":{
            "status": "not aproved"
            }
        }
        
        expect(JSON.parse(response.body)["message"]).to eq("updated")
        expect(response).to have_http_status(:ok)
      end

      it "should return status code not_found" do
        post "http://127.0.0.1:3000/api/v1/update_request/664",  headers: { "Authorization": @access_token }, params:
        {
            "leave_request":{
            "status": "not aproved"
            }
        }
        
        expect(JSON.parse(response.body)["message"]).to eq("not found")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
  
  
  
  
  
  
  


  


  private

  def login(manager)

      post "http://127.0.0.1:3000/manager_login", params: {
              
              
          "email": manager.email,
          "password": manager.password
      }
    
      @access_token = JSON.parse(response.body)['tokens']['access']

  end

end
