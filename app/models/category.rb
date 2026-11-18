class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :category_attributes, dependent: :destroy

  validates :name, presence: true
  validates :description, length: {maximum:200}

  enum :status, {
    inactive: "inactive",
    active: "active"
  }
end