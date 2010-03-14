class AddSubcategoryIdAndCategoryIdToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :category_id, :integer
    add_column :shops, :subcategory_id, :integer
  end

  def self.down
    remove_column :shops, :category_id
    remove_column :shops, :subcategory_id
  end
end
