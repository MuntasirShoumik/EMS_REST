class Employee < ApplicationRecord
  has_secure_password

  belongs_to :manager
  has_many :tasks, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_one :leave_count

  include Validations
  validates :position, presence: true
  validates :dept, presence: true
end
