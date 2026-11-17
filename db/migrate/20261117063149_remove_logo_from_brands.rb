class RemoveLogoFromBrands < ActiveRecord::Migration[7.0]
  def change
    remove_column :brands, :logo, :string
  end
end
