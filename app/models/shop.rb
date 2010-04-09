class Shop < ActiveRecord::Base
  ACTIVE = 1
  DEACTIVE = 2
  PENDING = 0
  SHORTNAME_FORMAT = /^[a-zA-Z0-9\-]{3,}$/i

  # plugins
  strip_attributes!
  #call back
  before_update :unchange_shortname
  belongs_to :owner, :class_name=>'User', :foreign_key=>'user_id'
  belongs_to :category
  belongs_to :subcategory, :conditions=>"parent_id is not null", :class_name=>'Category'
  has_many :shop_categories, :dependent=>:destroy
  has_many :subcategories , :through=>:shop_categories, :source => :subcategory
  has_many :products, :dependent=>:destroy
  has_many :addresses, :as=>:addressable, :dependent=>:destroy
  #  belongs_to :shop_layout
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

  def pending?
    self.status == PENDING
  end

  def do_activate
    if pending?
      activate
    end
  end

  def activate
    update_attribute(:status,ACTIVE)
  end

  def deactivate
    update_attribute(:status,DEACTIVE)
  end

  def to_liquid(options={})
    ShopDrop.new self, options
  end

  def call_render(template_type, assigns = {}, controller = nil, options = {})
    assigns.update('shop' => to_liquid)
    options.reverse_merge!(:layout => true)
    template = File.new("#{template_path}/#{template_type}.liquid", "r")
    if options[:layout]
      WeeShop::Liquid::LiquidTemplate.new(self).render(layout, template, assigns, controller)
    else
      WeeShop::Liquid::LiquidTemplate.new(self).parse_inner_template(template, assigns, controller)
    end
  end

  def template_path
    RAILS_ROOT+'/app/themes/1/code1'
  end

  def layout
    File.new(RAILS_ROOT+'/app/themes/1/code1/layout.liquid','r')
  end

  protected
  def unchange_shortname
    self.shortname = shortname_was
  end

end