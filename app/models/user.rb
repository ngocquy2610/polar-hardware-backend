class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  PHONE_REGEX = /\A\+?[0-9]{9,14}\z/
  validates :full_name, presence: true
  enum :role, {
    customer: 0,
    admin: 1
  }
  validates :phone, presence: true, uniqueness: true, format: { with: PHONE_REGEX, message: "không đúng định dạng" }
  validates :email, presence: true

  private

  def active_for_authentication? # a method already exist in devise
    super && active? # super means recall the def active_for_authentication? from devise and add condition about active?
  end

  def inactive_message
    active? ? super : :inactive
  end
end
