class AddMoreFieldsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :meta_description, :string
    add_column :products, :meta_keywords, :string
    add_column :products, :deleted_at, :string
    add_column :products, :type, :string
    add_column :products, :shop_category_id, :integer
    add_column :products, :sku, :string
  end

  def self.down
    remove_column :products, :meta_description
    remove_column :products, :meta_keywords
    remove_column :products, :deleted_at
    remove_column :products, :type
    remove_column :products, :shop_category_id
    remove_column :products, :sku
  end
end
