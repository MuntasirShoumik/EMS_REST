class LeaveRequest < ApplicationRecord
  belongs_to :employee

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :reason, presence: true
  validates :status, presence: true
  validate :validate_dates

  private

  def validate_dates
    if start_date.to_s !~ /\A\d{4}-\d{2}-\d{2}\z/ || end_date.to_s !~ /\A\d{4}-\d{2}-\d{2}\z/ 
      errors.add(:deadline, 'must be in the format YYYY-MM-DD')
    elsif start_date >= end_date
      errors.add(:deadline, 'starting date can not be equal or grater then ending date ')  
    end
  end
end
