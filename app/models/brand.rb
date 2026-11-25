class Brand < ApplicationRecord
  before_validation :generate_slug

  has_many :products, dependent: :destroy
  has_one_attached :logo, dependent: :destroy

  validates :name, presence: true
  validates :description, length: {maximum:200}

  enum :status, {
    active: "active",
    inactive: "inactive"
  }

  private

  def generate_slug
    return if name.blank? || slug.present?

    base_slug = name.parameterizes if slug.blank? && name.present?
    candidate_slug = base_slug
    count = 1

    while Brand.where.not(id: id).exist?(slug: candidate_slug)
      candidate_slug = "#{base_slug}-#{count}"
      count += 1
    end

    self.slug = candidate_slug
  end
end