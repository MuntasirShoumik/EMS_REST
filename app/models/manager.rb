class Manager < ApplicationRecord
    has_secure_password
    has_many :employees

    include Validations


end
