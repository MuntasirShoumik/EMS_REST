class ManagerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :email, :phone
end
