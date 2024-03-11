require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  include FactoryBot::Syntax::Methods

  describe "POST /manager_login" do
    context "when manager logs in" do

      before do
        @manager = create(:manager)
      end

      it "should return worng email or password with status code unauthorized" do
        post "http://127.0.0.1:3000/manager_login", params: {
                      
          "email": @manager.email,
          "password": "asas"
        }
          

            
        expect(JSON.parse(response.body)["message"]).to eq("Invalid email or password")
        expect(response).to have_http_status(:unauthorized) 
      end

      it "should return access_token and refresh_token with status code ok" do
        post "http://127.0.0.1:3000/manager_login", params: {
                      
          "email": @manager.email,
          "password": @manager.password
        }
        @access_token = JSON.parse(response.body)['tokens']['access']
        @refresh_token = JSON.parse(response.body)['tokens']['refresh']

        
        expect(@access_token.class).to eq("String".class)
        expect(@refresh_token.class).to eq("String".class)  

        expect(response).to have_http_status(:ok)  
      end  
    end
  end



  describe "DELETE /manager_logout" do
    context "when manager logout" do

      before do
        manager = create(:manager)
        @access_token, @refresh_token = login_manager(manager)

      end

      it "should return Logged out successfully and status code ok" do
        
        delete "http://127.0.0.1:3000/manager_logout", headers: { "Authorization": "#{@access_token} #{@refresh_token}" }
        expect(JSON.parse(response.body)['message']).to eq("Logged out successfully")
        expect(response).to have_http_status(:ok)  

      end

      it "should return Invalid tokens and status code unauthorized" do

        delete "http://127.0.0.1:3000/manager_logout", headers: { "Authorization": "#{@access_token}" }
        expect(JSON.parse(response.body)['message']).to eq("Invalid tokens")
        expect(response).to have_http_status(:unauthorized)

      end

      it "should return Login first and status code unauthorized" do
        delete "http://127.0.0.1:3000/manager_logout", headers: { "Authorization": "" }
        expect(JSON.parse(response.body)['message']).to eq("Login first")
        expect(response).to have_http_status(:unauthorized)
      end
      
    end
    
    
  end
  

  describe "POST/emp_login" do

    before do
      manager = create(:manager)
      @employee = create(:employee, manager_id: manager.id)
    end

    it "should return worng email or password with status code unauthorized" do
      post "http://127.0.0.1:3000/emp_login", params: {
                
        
        "email": @employee.email,
        "password": "33dfe"
      }

      expect(JSON.parse(response.body)["message"]).to eq("Invalid email or password")
      expect(response).to have_http_status(:unauthorized) 
    end

    it "should return access_token and refresh_token with status code ok" do
      post "http://127.0.0.1:3000/emp_login", params: {
                    
                    
        "email": @employee.email,
        "password": @employee.password
      }
      @access_token = JSON.parse(response.body)['tokens']['access']
      @refresh_token = JSON.parse(response.body)['tokens']['refresh']

    
      expect(@access_token.class).to eq("String".class)
      expect(@refresh_token.class).to eq("String".class)
    end
  end

  describe "DELETE /employee_logout" do
    context "when employee logout" do

      before do
        manager = create(:manager)
        employee = create(:employee, manager_id: manager.id)
        @access_token, @refresh_token = login_employee(employee)

      end

      it "should return Logged out successfully and status code ok" do
        delete "http://127.0.0.1:3000/emp_logout", headers: { "Authorization": "#{@access_token} #{@refresh_token}" }
        expect(JSON.parse(response.body)['message']).to eq("Logged out successfully")
        expect(response).to have_http_status(:ok)  
      end

      it "should return Invalid tokens and status code unauthorized" do
        delete "http://127.0.0.1:3000/emp_logout", headers: { "Authorization": "#{@access_token}" }
        expect(JSON.parse(response.body)['message']).to eq("Invalid tokens")
        expect(response).to have_http_status(:unauthorized)
      end

      it "should return Login first and status code unauthorized" do
        delete "http://127.0.0.1:3000/emp_logout", headers: { "Authorization": "" }
        expect(JSON.parse(response.body)['message']).to eq("Login first")
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
    
      @access_token, @refresh_token = JSON.parse(response.body)['tokens']['access'], JSON.parse(response.body)['tokens']['refresh']

  end

  def login_employee(employee)

    post "http://127.0.0.1:3000/emp_login", params: {
            
            
        "email": employee.email,
        "password": employee.password
    }
  
    @access_token, @refresh_token = JSON.parse(response.body)['tokens']['access'], JSON.parse(response.body)['tokens']['refresh']
    

end
  
end
