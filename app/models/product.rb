class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand

  has_many :product_specifications

  validates :name, presence: true
  validates :slug, presence: true
  validates :sku, presence: true
  validates :description, length: {maximum:200}

  validates :price, presence: true

  enum :stock_status, {
    instock: "instock",
    out_of_stock: "out_of_stock",
    coming_soon: "coming_soon"
  }

  enum :status, {
    active: "active",
    inactive: "inactive"
  }
end