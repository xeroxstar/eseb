class AddLagAndLngToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :lat, :decimal, :precision => 15, :scale => 10
    add_column :addresses, :lng, :decimal, :precision => 15, :scale => 10
    add_index :addresses, [:lat, :lng]
  end

  def self.down
    remove_index  :addresses, [:lat, :lng]
    remove_column :addresses, :lat
    remove_column :addresses, :lng
  end
end
