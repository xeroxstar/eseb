class Category < ActiveRecord::Base
  acts_as_tree :order=>'name'
  #asscociation
  has_many :shops, :conditions=>{:status=>Shop::ACTIVE}

  validates_presence_of :name, :shortname

  named_scope :subcategories, :conditions=>"categories.parent_id is NOT NULL"
  named_scope :main , :conditions=>"categories.parent_id is NULL"

  class << self
    def collection
      main.collect { |c|
        [c.name,c.id]
      }
    end

    def subcollection
      subcategories.collect { |c|
        [c.name,c.id]
      }
    end
  end
end
