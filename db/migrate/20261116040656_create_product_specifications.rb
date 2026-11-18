class CreateProductSpecifications < ActiveRecord::Migration[7.0]
  def change
    create_table :product_specifications do |t|
      t.references :product, null: false, foreign_key: true
      t.references :category_attribute, null: false, foreign_key: true
      t.string :value_string
      t.decimal :value_number
      t.boolean :value_boolean

      t.timestamps
    end

    add_index :product_specifications,
              [:product_id, :category_attribute_id],
              unique: true,
              name: "idx_product_specs_product_category_attribute"
  end
end
