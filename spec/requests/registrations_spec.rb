require 'rails_helper'

RSpec.describe "Testting Registrations", type: :request do
  include FactoryBot::Syntax::Methods

  describe "POST /signup" do
    context "when manager sigin up" do
      it "should return status created" do
        post "http://127.0.0.1:3000/signup", params: {
                
          "name": "muntasir",
          "email": "test@gmail.com",
          "phone": "01973648298",
          "password": "1111",
          "password_confirmation": "1111"
      }
    
      expect(response).to have_http_status(:created)
      end
    end
    
    it "should return validation errors for email, phone, password with status code unprocessable entity" do
      post "http://127.0.0.1:3000/signup", params: {
          
          "name": "muntasir",
          "email": "test",
          "phone": "019736wsd8298",
          "password": "11114",
          "password_confirmation": "1111"
      }


    
      expect(response).to have_http_status(:unprocessable_entity)

      expect(JSON.parse(response.body)["errors"]["details"][0]["email"][0]).to eq("Enter vaid email.")
      expect(JSON.parse(response.body)["errors"]["details"][0]["phone"][0]).to eq("is not a number")
      expect(JSON.parse(response.body)["errors"]["details"][0]["password_confirmation"][0]).to eq("doesn't match Password")
   end
  end
end
