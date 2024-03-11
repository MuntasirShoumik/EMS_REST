class Task < ApplicationRecord
  belongs_to :employee

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true

  validate :validate_deadline_format

  private

  def validate_deadline_format
    if deadline.nil? || deadline.to_s !~ /\A\d{4}-\d{2}-\d{2}\z/
      errors.add(:deadline, 'must be in the format YYYY-MM-DD')
    end
  end

end
