# spec/models/leave_request_spec.rb
require 'rails_helper'

RSpec.describe LeaveRequest, type: :model do
  include FactoryBot::Syntax::Methods
  let(:leave_request) { LeaveRequest.new }

  before do
    @manager = create(:manager)
    @employee = create(:employee, manager_id: @manager.id)
    leave_request.employee_id = @employee.id
  end

  it "is valid with valid attributes" do
    leave_request.start_date = Date.today
    leave_request.end_date = Date.tomorrow
    leave_request.reason = "Vacation"
    leave_request.status = "Pending"

    expect(leave_request).to be_valid
  end

  it "is not valid without a start date" do
    leave_request.start_date = nil
    leave_request.end_date = Date.tomorrow
    leave_request.reason = "Vacation"
    leave_request.status = "Pending"

    expect(leave_request).not_to be_valid
    expect(leave_request.errors[:start_date]).to include("can't be blank")
  end

  it "is not valid without an end date" do
    leave_request.start_date = Date.today
    leave_request.end_date = nil
    leave_request.reason = "Vacation"
    leave_request.status = "Pending"

    expect(leave_request).not_to be_valid
    expect(leave_request.errors[:end_date]).to include("can't be blank")
  end

  it "is not valid without a reason" do
    leave_request.start_date = Date.today
    leave_request.end_date = Date.tomorrow
    leave_request.status = "Pending"
    leave_request.reason = nil

    expect(leave_request).not_to be_valid
    expect(leave_request.errors[:reason]).to include("can't be blank")
  end

  it "is not valid without a status" do
    leave_request.start_date = Date.today
    leave_request.end_date = Date.tomorrow
    leave_request.reason = "Vacation"
    leave_request.status = nil

    expect(leave_request).not_to be_valid
    expect(leave_request.errors[:status]).to include("can't be blank")
  end

  it "is not valid if start date is greater than or equal to end date" do
    leave_request.start_date = Date.tomorrow
    leave_request.end_date = Date.today
    leave_request.reason = "Vacation"
    leave_request.status = "Pending"

    expect(leave_request).not_to be_valid
    expect(leave_request.errors[:deadline]).to include("starting date can not be equal or grater then ending date ")
  end

  it "is not valid if dates are not in the 'YYYY-MM-DD' format" do
    leave_request.start_date = "2022-13-01"
    leave_request.end_date = "2022-12-01"
    leave_request.reason = "Vacation"
    leave_request.status = "Pending"

    expect(leave_request).not_to be_valid
    expect(leave_request.errors[:deadline]).to include("must be in the format YYYY-MM-DD")
  end

  it "belongs to an employee" do
    association = described_class.reflect_on_association(:employee)
    expect(association.macro).to eq(:belongs_to)
  end
end
