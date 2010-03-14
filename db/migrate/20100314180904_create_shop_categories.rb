class CreateShopCategories < ActiveRecord::Migration
  def self.up
    create_table :shop_categories do |t|
      t.string :name
      t.integer :subcategory_id
      t.integer :shop_id
      t.timestamps
    end
  end

  def self.down
    drop_table :shop_categories
  end
end
