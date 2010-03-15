class Category < ActiveRecord::Base
  acts_as_tree :order=>'name'

  #asscociation
  has_many :shops, :conditions=>{'shops.status'=>Shop::ACTIVE}

  validates_presence_of :name, :shortname

  named_scope :subcategories, :conditions=>"categories.parent_id is NULL"
end
