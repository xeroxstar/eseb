class RemoveAddressFieldsInUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :address
    remove_column :users, :country_id
    remove_column :users, :city
  end

  def self.down
  end
end
