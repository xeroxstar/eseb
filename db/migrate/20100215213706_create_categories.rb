class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :shortname
      t.integer :parent_id
    end
  end

  def self.down
    drop_table :categories
  end
end
