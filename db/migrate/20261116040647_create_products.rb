class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sku, null: false
      t.string :product_type
      t.text :description
      t.decimal :price, precision: 15, scale: 2, null: false
      t.decimal :compare_at_price, precision: 15, scale: 2, null: false
      t.decimal :cost_price, precision: 15, scale: 2
      t.string :stock_status, null: false
      t.string :status, null: false

      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
  end
end
