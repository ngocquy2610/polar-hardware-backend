# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
brand = Brand.find_or_initialize_by(slug: "apple")
brand.assign_attributes(
  name: "Apple",
  description: "Apple Inc.",
  status: "active"
)
brand.save!

unless brand.logo.attached?
  image_path = Rails.root.join("image/logo/logo_apple.png")

  File.open(image_path, "rb") do |file|
    brand.logo.attach(
      io: file,
      filename: "logo_apple.png",
      content_type: "image/png"
    )
  end
end

inactive_brand = Brand.find_or_initialize_by(slug: "sample-legacy-hardware")
inactive_brand.assign_attributes(
  name: "Sample Legacy Hardware",
  description: "A sample inactive hardware brand.",
  status: "inactive"
)
inactive_brand.save!

[
  { slug: "sample-modern-hardware", name: "Sample Modern Hardware", description: "A sample active hardware brand.", status: "active" },
  { slug: "sample-retired-hardware", name: "Sample Retired Hardware", description: "Another sample inactive hardware brand.", status: "inactive" }
].each do |attributes|
  sample_brand = Brand.find_or_initialize_by(slug: attributes[:slug])
  sample_brand.assign_attributes(attributes)
  sample_brand.save!
end

users = [
  { email: "admin-active@example.test", full_name: "Active Admin", phone: "0900000001", role: :admin, active: true },
  { email: "admin-inactive@example.test", full_name: "Inactive Admin", phone: "0900000002", role: :admin, active: false },
  { email: "customer-active@example.test", full_name: "Active Customer", phone: "0900000003", role: :customer, active: true },
  { email: "customer-inactive@example.test", full_name: "Inactive Customer", phone: "0900000004", role: :customer, active: false }
]

unless Rails.env.production?
  users.each do |attributes|
    user = User.find_or_initialize_by(email: attributes[:email])
    user.assign_attributes(attributes)
    user.password = "SamplePassword123!" if user.new_record?
    user.save!
  end
end

categories = [
  { slug: "sample-laptops", name: "Sample Laptops", description: "Sample laptop products.", status: "active" },
  { slug: "sample-monitors", name: "Sample Monitors", description: "Sample monitor products.", status: "inactive" },
  { slug: "sample-keyboards", name: "Sample Keyboards", description: "Sample keyboard products.", status: "active" },
  { slug: "sample-tablets", name: "Sample Tablets", description: "Sample tablet products.", status: "inactive" }
].index_with do |attributes|
  category = Category.find_or_initialize_by(slug: attributes[:slug])
  category.assign_attributes(attributes)
  category.save!
  category
end.values.index_by(&:slug)

category_attributes = {}
categories.each do |slug, category|
  attributes = [
    { name: "model", label: "Model", data_type: "string", unit: "text", is_required: true, is_filterable: true },
    { name: "screen_size", label: "Screen size", data_type: "number", unit: "inch", is_required: true, is_filterable: true },
    { name: "touchscreen", label: "Touchscreen", data_type: "boolean", unit: "yes/no", is_required: false, is_filterable: false }
  ]

  category_attributes[slug] = attributes.index_with do |values|
    attribute = category.category_attributes.find_or_initialize_by(name: values[:name])
    attribute.assign_attributes(values)
    attribute.save!
    attribute
  end.values.index_by(&:name)
end

products = [
  { sku: "SAMPLE-LAPTOP-001", name: "Sample Laptop 13", category: "sample-laptops", brand: brand, price: 1200, compare_at_price: 1400, cost_price: 900, stock_status: "instock", status: "active", screen_size: 13, touchscreen: true },
  { sku: "SAMPLE-LAPTOP-002", name: "Sample Laptop 15", category: "sample-laptops", brand: brand, price: 1500, compare_at_price: 1600, cost_price: 1100, stock_status: "out_of_stock", status: "active", screen_size: 15, touchscreen: false },
  { sku: "SAMPLE-LAPTOP-003", name: "Sample Laptop 16", category: "sample-laptops", brand: brand, price: 1800, compare_at_price: 1900, cost_price: nil, stock_status: "coming_soon", status: "inactive", screen_size: 16, touchscreen: nil },
  { sku: "SAMPLE-MONITOR-001", name: "Sample Monitor 24", category: "sample-monitors", brand: inactive_brand, price: 200, compare_at_price: 250, cost_price: 150, stock_status: "instock", status: "inactive", screen_size: 24, touchscreen: false },
  { sku: "SAMPLE-MONITOR-002", name: "Sample Monitor 27", category: "sample-monitors", brand: inactive_brand, price: 300, compare_at_price: 350, cost_price: 220, stock_status: "out_of_stock", status: "inactive", screen_size: 27, touchscreen: true },
  { sku: "SAMPLE-MONITOR-003", name: "Sample Monitor 32", category: "sample-monitors", brand: inactive_brand, price: 400, compare_at_price: 450, cost_price: nil, stock_status: "coming_soon", status: "active", screen_size: 32, touchscreen: false }
]

products.each do |values|
  category_slug = values[:category]
  product = Product.find_or_initialize_by(sku: values[:sku])
  product.assign_attributes(
    values.except(:category, :screen_size, :touchscreen).merge(
      category: categories.fetch(category_slug),
      slug: values[:sku].downcase,
      description: "Sample #{values[:name].downcase}."
    )
  )
  product.save!

  specifications = {
    "model" => { value_string: values[:name] },
    "screen_size" => { value_number: values[:screen_size] },
    "touchscreen" => { value_boolean: values[:touchscreen] }
  }

  specifications.each do |name, value|
    specification = product.product_specifications.find_or_initialize_by(
      category_attribute: category_attributes.fetch(category_slug).fetch(name)
    )
    specification.assign_attributes({ value_string: nil, value_number: nil, value_boolean: nil }.merge(value))
    specification.save!
  end
end