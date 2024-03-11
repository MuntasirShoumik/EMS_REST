class LeaveRequestSerializer
  include FastJsonapi::ObjectSerializer
  attributes :start_date, :end_date, :reason, :status


  belongs_to :employee 
end
