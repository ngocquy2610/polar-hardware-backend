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
    return if slug.present? || name.blank?

    base_slug = name.parameterize if slug.blank? && name.present?
    # parameterize to nomalize string "Polar Keyboard" to "polar-keyboard"
    candidate_slug = base_slug
    count = 1

    while Brand.where.not(id: id).exists?(slug: candidate_slug)
      # where not id: id to remove current product out of checking
      candidate_slug = "#{base_slug}-#{count}"
      count += 1
    end

    self.slug = candidate_slug
  end
end