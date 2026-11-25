class Product < ApplicationRecord
  before_validation :generate_slug

  belongs_to :category
  belongs_to :brand

  has_many :product_specifications, dependent: :destroy

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

  private

  def generate_slug
    return if slug.present? || name.blank?

    base_slug = name.parameterize if slug.blank? && name.present?
    # parameterize to nomalize string "Polar Keyboard" to "polar-keyboard"
    candidate_slug = base_slug
    count = 1

    while Product.where.not(id: id).exists?(slug: candidate_slug)
      # where not id: id to remove current product out of checking
      candidate_slug = "#{base_slug}-#{count}"
      count += 1
    end

    self.slug = candidate_slug
  end
end