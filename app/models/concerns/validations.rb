module Validations
  extend ActiveSupport::Concern
 
  included do
    validates :name, presence: true
    validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Enter vaid email.' }
    validates :phone, numericality: { only_integer: true }
  end

end