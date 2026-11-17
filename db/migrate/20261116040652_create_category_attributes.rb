class CreateCategoryAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :category_attributes do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.string :label, null: false
      t.string :data_type, null: false
      t.string :unit, null: false
      t.boolean :is_required, null: false, default: false
      t.boolean :is_filterable, null: false, default: false

      t.timestamps
    end

    add_index :category_attributes,
          [:category_id, :name],
          unique: true
  end
end