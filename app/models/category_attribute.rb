class CategoryAttribute < ApplicationRecord
  belongs_to :category

  has_many :product_specifications, dependent: :destroy

  validates :name, presence: true
  validates :label, presence:true

  validates :data_type, presence: true
  validates :unit, presence: true

  validates :is_required, inclusion: { in: [true, false] }
  validates :is_filterable, inclusion: { in: [true, false] }
end