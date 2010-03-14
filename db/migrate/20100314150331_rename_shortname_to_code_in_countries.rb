class RenameShortnameToCodeInCountries < ActiveRecord::Migration
  def self.up
    rename_column(:contries, :shortname, :code)
  end

  def self.down
    rename_column(:contries, :code, :shortname)
  end
end