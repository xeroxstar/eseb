class AddMoreInfoForShopOwner < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :social_id, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :country_id, :integer
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :social_id
    remove_column :users, :address
    remove_column :users, :city
    remove_column :users, :country_id
  end
end
