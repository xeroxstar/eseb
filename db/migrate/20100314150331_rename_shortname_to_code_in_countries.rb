class RenameShortnameToCodeInCountries < ActiveRecord::Migration
  def self.up
    rename_column(:countries, :shortname, :code)
  end

  def self.down
    rename_column(:countries, :code, :shortname)
  end
end