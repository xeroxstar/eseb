class Category < ActiveRecord::Base
  acts_as_tree :order=>'name'

  validates_presence_of :name, :shortname
end
