class AddCurrentThemeToShops < ActiveRecord::Migration
  def self.up
    add_column :shops,:current_theme,:string
  end

  def self.down
    remove_column :shops,:current_theme,:string
  end
end
