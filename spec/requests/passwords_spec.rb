require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  include FactoryBot::Syntax::Methods

  describe "PATCH /manager_password_reset" do
    context "When Manager reset pasword" do

      before do
        @manager = create(:manager)
        @access_token = login_manager(@manager)
      end

      it "should return password updated with status code ok" do
        patch "http://127.0.0.1:3000/manager_password_reset", headers: { "Authorization": @access_token }, params: {
          "current_password": @manager.password,
          "update":{
              
              "password": "1111",
              "password_confirmation": "1111"
          }
        }

        expect(JSON.parse(response.body)['message']).to eq("password updated")
        expect(response).to have_http_status(:ok)  
      end

      it "should return doesn't match Password with status code unauthorized" do
        patch "http://127.0.0.1:3000/manager_password_reset", headers: { "Authorization": @access_token }, params: {
          "current_password": @manager.password,
          "update":{
              
              "password": "1111",
              "password_confirmation": "1111dsdsd"
          }
        }

        expect(JSON.parse(response.body)["errors"]["details"][0]["password_confirmation"][0]).to eq("doesn't match Password")
        expect(response).to have_http_status(:unauthorized)  
      
      end

      it "should return Invalid password with status code unauthorized" do
        patch "http://127.0.0.1:3000/manager_password_reset", headers: { "Authorization": @access_token }, params: {
          "current_password": "2121212",
          "update":{
              
              "password": "1111",
              "password_confirmation": "1111"
          }
        }

        expect(JSON.parse(response.body)['message']).to eq("Invalid password")
        expect(response).to have_http_status(:unauthorized) 
      end
    end
  end

  describe "PATCH /emp_password_reset" do
    context "When Employee resets password" do

      before do
        manager = create(:manager)
        @employee = create(:employee, manager_id: manager.id)
        @access_token = login_employee(@employee)
      end

      it "should return whith status code " do
        patch "http://127.0.0.1:3000/emp_password_reset", headers: { "Authorization": @access_token }, params: {
          "current_password": @employee.password,
          "update":{
              
              "password": "1111",
              "password_confirmation": "1111"
          }
        }

        expect(JSON.parse(response.body)['message']).to eq("password updated")
        expect(response).to have_http_status(:ok)  
      end

      it "should return whith status code " do
        patch "http://127.0.0.1:3000/emp_password_reset", headers: { "Authorization": @access_token }, params: {
          "current_password": @employee.password,
          "update":{
              
              "password": "1111",
              "password_confirmation": "1111dsdsd"
          }
        }

        expect(JSON.parse(response.body)["errors"]["details"][0]["password_confirmation"][0]).to eq("doesn't match Password")
        expect(response).to have_http_status(:unauthorized)  
      end

      it "should return whith status code " do
        patch "http://127.0.0.1:3000/emp_password_reset", headers: { "Authorization": @access_token }, params: {
          "current_password": "2121212",
          "update":{
              
              "password": "1111",
              "password_confirmation": "1111"
          }
        }

        expect(JSON.parse(response.body)['message']).to eq("Invalid password")
        expect(response).to have_http_status(:unauthorized) 
      end
      
    end
    
    
  end
  


  private

  def login_manager(manager)

      post "http://127.0.0.1:3000/manager_login", params: {
              
              
          "email": manager.email,
          "password": manager.password
      }
    
      @access_token= JSON.parse(response.body)['tokens']['access']

  end

  def login_employee(employee)

    post "http://127.0.0.1:3000/emp_login", params: {
            
            
        "email": employee.email,
        "password": employee.password
    }
  
    @access_token= JSON.parse(response.body)['tokens']['access']
    

  end
end
