class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name
      t.string :code
      t.belongs_to :country
    end
    create_table :addresses do |t|
      t.belongs_to :addressable, :polymorphic => true
      t.string :street
      t.string :state # Districts
      t.belongs_to :city
      t.integer :country_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cities
    drop_table :addresses
  end
end
