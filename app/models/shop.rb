class Shop < ActiveRecord::Base
  after_create :import_default_theme, :publish_shop_to_fb
  before_create :downcase_shopname
  before_update :unchange_shortname
  @@theme_path      = Object::THEME_ROOT
  cattr_reader :theme_path
  # Copy from mephisto
  # @@template_handlers = HashWithIndifferentAccess.new if @@template_handlers.nil?
  @@template_handlers = {}

  # Register a class that knows how to handle template files with the given
  # extension. This can be used to implement new template types.
  # The constructor for the class must take a Site instance
  # as a parameter, and the class must implement a #render method that
  # has the following signature
  # def render(section, layout, template, assigns ={}, controller = nil)
  # and return the rendered template as a string.
  def self.register_template_handler(extension, klass)
    @@template_handlers[extension] = klass
  end
  register_template_handler(".liquid", WeeShop::Liquid::LiquidTemplate)

  def self.extensions
    @@template_handlers.keys
  end


  ACTIVE = 1
  DEACTIVE = 2
  PENDING = 0
  SHORTNAME_FORMAT = /^[a-zA-Z0-9\-]{3,}$/i

  # plugins
  strip_attributes!
  #call back
  belongs_to :owner, :class_name=>'User', :foreign_key=>'user_id'
  belongs_to :category
  belongs_to :subcategory, :conditions=>"parent_id is not null", :class_name=>'Category'
  has_many :shop_categories, :dependent=>:destroy
  has_many :subcategories , :through=>:shop_categories, :source => :subcategory
  has_many :products, :dependent=>:destroy
  has_many :addresses, :as=>:addressable, :dependent=>:destroy
  #  belongs_to :shop_layout
  has_many :categories , :through=>:products

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

  def main_branch_address
    addresses.first
  end
  def lat
    main_branch_address.lat
  end
  
  def lng
    main_branch_address.lng
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

  def theme_path
    @theme_path ||= self.class.theme_path + "site-#{id}"
  end

  def import_theme(zip_file, name)
    imported_name = Theme.import zip_file, :to => theme_path + name
    imported_name
  end

  def themes
    return @themes unless @themes.nil?
    @themes = []
    FileUtils.mkdir_p theme_path
    Dir.foreach theme_path do |e|
      next if e.first == '.'
      entry = theme_path + e
      next unless entry.directory?
      @themes << Theme.new(entry, self)
    end
    def @themes.[](key) key = key.to_s ; detect { |t| t.name == key } ; end
    @themes.sort! {|a,b| a.name <=> b.name}
  end

  def theme
    @theme = themes[current_theme_path]|| themes.first
  end

  def current_theme_path
    current_theme||'default'
  end

  def template_path
    "#{theme_path}/#{current_theme_path}/templates"
  end

  def layout
    File.new("#{theme_path}/#{current_theme_path}/layouts/layout.liquid",'r')
  end

  def to_fb_attachment
     attachment = {:caption=>"{*actor*} create a shop from weeshop",
#                  :description=>"#{description}",
                  :name=>name,
                  :href=>"http://robdoan.homedns.org:3000/#{shortname}"}
#    medias = []
#    for image in images do
#      medias << {:type=>'image',
#        :src=>"http://robdoan.homedns.org:3000#{image.attachment.url(:mini)}",
#        :href=>"http://robdoan.homedns.org:3000#{image.attachment.url(:product)}" }
#    end
#    if !medias.blank?
#      attachment = attachment.merge(:media=>medias)
#    end
    attachment
  end

  def publish_shop_to_fb
    owner.publish_created_shop
  end

  protected
  def unchange_shortname
    self.shortname = shortname_was
  end

  def downcase_shopname
    self.shortname = self.shortname.downcase
  end

  def import_default_theme
    Theme.add_global_theme_to_shop(current_theme_path,self)
  end

end