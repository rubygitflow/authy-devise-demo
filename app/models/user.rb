class User < ApplicationRecord
  include Auxiliary

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Normalizes the attribute itself before validation
  phony_normalize :phone, default_country_code: 'RU'

  EMAIL_VALIDATION = /.+@.+\..+/i

  validates :phone, :email, presence: true

  validates :email, uniqueness: true, 
    format: { with: EMAIL_VALIDATION, message: "Invalid email format" }

  def country_code
    @country_code ||= PhonyRails.country_code_from_number(phone)
  end  

  def phone_number
    @phone_number ||= Phony.formatted(Phony.normalize(phone))
  end  

  def random_email
    @random_email ||= random_string+'@email.com'
  end

  def authy_turn_off
    update!(authy_enabled: false)
  end
end
