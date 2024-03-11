# spec/models/task_spec.rb
require 'rails_helper'

RSpec.describe Task, type: :model do
  include FactoryBot::Syntax::Methods
  let(:task) { Task.new }

  before do
    @manager = create(:manager)
    @employee = create(:employee, manager_id: @manager.id)
    task.employee_id = @employee.id
  end

  it "is valid with valid attributes" do
    task.title = "Complete Project"
    task.description = "Finish the project by the deadline"
    task.status = "Incomplete"
    task.deadline = "2023-12-31"
    expect(task).to be_valid
  end

  it "is not valid without a title" do
    task.description = "Finish the project by the deadline"
    task.status = "Incomplete"
    task.deadline = "2023-12-31"
    expect(task).not_to be_valid
    expect(task.errors[:title]).to include("can't be blank")
  end

  it "is not valid without a description" do
    task.title = "Complete Project"
    task.status = "Incomplete"
    task.deadline = "2023-12-31"
    expect(task).not_to be_valid
    expect(task.errors[:description]).to include("can't be blank")
  end

  it "is not valid without a status" do
    task.title = "Complete Project"
    task.description = "Finish the project by the deadline"
    task.deadline = "2023-12-31"
    expect(task).not_to be_valid
    expect(task.errors[:status]).to include("can't be blank")
  end

  it "is not valid if deadline is not in the format YYYY-MM-DD" do
    task.title = "Complete Project"
    task.description = "Finish the project by the deadline"
    task.status = "Incomplete"
    task.deadline = "invalid_date_format"
    expect(task).not_to be_valid
    expect(task.errors[:deadline]).to include("must be in the format YYYY-MM-DD")
  end

  it "belongs to an employee" do
    association = described_class.reflect_on_association(:employee)
    expect(association.macro).to eq(:belongs_to)
  end
end
