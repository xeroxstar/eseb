class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, :precision =>12,:scale => 2, :default => 0
      t.integer :quantity , :default => 0
      t.datetime :avaiable_date
      t.datetime :expired_date
      t.integer :category_id
      t.integer :shop_id
      t.timestamps
    end
    add_column :shops, :products_counter,:integer, :default => 0
  end

  def self.down
    drop_table :products
    remove_column :shops, :products_counter
  end
end
