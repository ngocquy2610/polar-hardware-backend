class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug
      t.text :description
      t.string :status, null: false, default: "inactive"

      t.timestamps
    end
  end
end
