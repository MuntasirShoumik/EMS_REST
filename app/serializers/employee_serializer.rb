class EmployeeSerializer
  include FastJsonapi::ObjectSerializer
  # attributes
  attributes  :name, :email, :phone, :position, :dept

  belongs_to :manager
  # has_many :tasks
  # has_many :leave_requests
  # has_one :leave_count
end
