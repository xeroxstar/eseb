class CreateShopLayouts < ActiveRecord::Migration
  
  def self.up
    create_table :shop_layouts do |t|
      t.string :name
      t.integer :creator_id
      t.string :code
      t.string :shop_layout
      t.string :categories
      t.string :banner
      t.string :product
      t.string :product_detail
      t.boolean :published
    end
    
  end

  def self.down
    drop_table :shop_layouts
  end
end
