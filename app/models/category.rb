class Category < ApplicationRecord
  has_many :products
  has_many :category_attributes

  validates :name, presence: true
  validates :description, length: {maximum:200}

  enum :status, {
    inactive: "inactive",
    active: "active"
  }
end