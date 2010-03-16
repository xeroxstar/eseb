class Shop < ActiveRecord::Base
  ACTIVE = 1
  DEACTIVE = 2
  SHORTNAME_FORMAT = /^[a-zA-Z0-9\-]{3,}$/i
  
  # plugins
  strip_attributes!
  
  #call back
  before_update :unchange_shortname
  belongs_to :owner, :class_name=>'User', :foreign_key=>'user_id'
  belongs_to :category
  belongs_to :subcategory, :conditions=>"parent_id is not null", :class_name=>'Category'
  has_many :products
  has_many :shop_categories, :dependent=>:destroy
  has_many :subcategories , :through=>:shop_categories, :source => :subcategory
  has_many :products
  #  has_many :categories , :through=>:products

  #validation
  validates_presence_of     :shortname, :category_id
  validates_format_of       :shortname , :with=>SHORTNAME_FORMAT
  validates_uniqueness_of   :shortname

  validates_presence_of     :name

  validates_uniqueness_of   :user_id

  named_scope :actived , :conditions=>{:status=>ACTIVE}

  # return all custom categories of shops
  def shopcategories_collection
    shop_categories.collect { |c|
      [c.name,c.id]
    }
  end

  # return all sub categories of shops
  def subcategories_collection
    subcategories.collect { |c|
      [c.name,c.id]
    }
  end

  def unactive?
    self.status == DEACTIVE
  end

  def active?
    self.status == ACTIVE
  end

  def activate
    update_attribute(:status,ACTIVE)
  end

  def deactivate
    update_attribute(:status,DEACTIVE)
  end

  protected
  def unchange_shortname
    self.shortname = shortname_was
  end

end