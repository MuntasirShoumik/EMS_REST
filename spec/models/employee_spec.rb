require 'rails_helper'

RSpec.describe Employee, type: :model do
    include FactoryBot::Syntax::Methods
    let(:employee) { Employee.new }

    before do
        @manager = create(:manager)

        employee.manager_id = @manager.id
        employee.password = "1111"
        employee.password_confirmation = "1111"
        employee.created_at = Date.current
        employee.updated_at = Date.current
    end
    it "is valid with valid attributes" do
      employee.id = 1  
      employee.name = "John Doe"
      employee.email = "john.doe@example.com"
      employee.phone = 1234567890
      employee.position = "Manager"
      employee.dept = "HR"


      expect(employee).to be_valid
    end


    it "is not valid without a name" do
        employee.id = 1  
        employee.name = nil
        employee.email = "john.doe@example.com"
        employee.phone = 1234567890
        employee.position = "Manager"
        employee.dept = "HR"
        expect(employee).to_not be_valid
        expect(employee.errors[:name]).to include("can't be blank")
    end
    

    it "is not valid without a valid email" do
        employee.id = 1  
        employee.name = "muntasir"
        employee.email = "not a valid email"
        employee.phone = 1234567890
        employee.position = "Manager"
        employee.dept = "HR"
        expect(employee).not_to be_valid
        expect(employee.errors[:email]).to include("Enter vaid email.")
      end
    
      it "is not valid without an integer phone number" do
        employee.id = 1  
        employee.name = "muntasir"
        employee.email = "john.doe@example.com"
        employee.phone = "123456hd90"
        employee.position = "Manager"
        employee.dept = "HR"
        expect(employee).not_to be_valid
        expect(employee.errors[:phone]).to include("is not a number")
      end
    
      it "is not valid without a position" do
        employee.id = 1  
        employee.name = "muntasir"
        employee.email = "john.doe@example.com"
        employee.phone = 1234567890
        employee.position = nil
        employee.dept = "HR"
        expect(employee).not_to be_valid
        expect(employee.errors[:position]).to include("can't be blank")
      end
    
      it "is not valid without a department" do
        employee.id = 1  
        employee.name = "muntasir"
        employee.email = "john.doe@example.com"
        employee.phone = 1234567890
        employee.position = "Manager"
        employee.dept = nil
        expect(employee).not_to be_valid
        expect(employee.errors[:dept]).to include("can't be blank")
      end


    
      it "has a manager association" do
        association = described_class.reflect_on_association(:manager)
        expect(association.macro).to eq(:belongs_to)
      end
    
      it "has many tasks association" do
        association = described_class.reflect_on_association(:tasks)
        expect(association.macro).to eq(:has_many)
        expect(association.options[:dependent]).to eq(:destroy)
      end
    
      it "has many leave_requests association" do
        association = described_class.reflect_on_association(:leave_requests)
        expect(association.macro).to eq(:has_many)
        expect(association.options[:dependent]).to eq(:destroy)
      end
    
      it "has one leave_count association" do
        association = described_class.reflect_on_association(:leave_count)
        expect(association.macro).to eq(:has_one)
      end

end
