class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name
      t.string :shortname
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
