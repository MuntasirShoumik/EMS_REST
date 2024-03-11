class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :status


  belongs_to :employee
end
