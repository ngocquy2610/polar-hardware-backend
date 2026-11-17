class Brand < ApplicationRecord
  has_many :products
  has_one_attached :logo

  validates :name, presence: true
  validates :description, length: {maximum:200}
end