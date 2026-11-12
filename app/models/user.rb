class User < ApplicationRecord
  PHONE_REGEX = /\A\+?[0-9]{9,14}\z/
  validates :full_name, presence: true
  enum :role, {
    customer: 0,
    admin: 1
  }
  validates :phone, presence: true, uniqueness: true, format: { with: PHONE_REGEX, message: "không đúng định dạng" }
  validates :email, presence: true
  
end
