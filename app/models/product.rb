# Product
# Represent entity for sale
# A store will have one or many product, and each product belogns to a store
# Product should belongs to a subcateogry , and may be belongs to shop categories
# Shop category must be depend on subcategory

class Product < ActiveRecord::Base
  strip_attributes!
  after_save :add_images
  before_create :shop_user_syn
#  after_create :published_to_facebook
  # Asscociations
  belongs_to :subcategory, :foreign_key => 'category_id', :class_name=>'Category'
  belongs_to :shop_category
  belongs_to :shop
  belongs_to :user
  has_many :images, :as=>:viewable,:dependent => :destroy
  attr_writer :image_ids
  attr_accessor :add_to_shop

  #named scope
  named_scope :in_shop_category , lambda{ |shop_category_id|
    {:conditions=> {:shop_category_id=>shop_category_id}}
  }
  named_scope :avaiable, {:conditions=>{:deleted_at=>nil}}

  #validation
  validates_presence_of :name
  # return ids of product images
  def image_ids
    images.map(&:id).join(',')
  end

  def add_to_shop=(value)
    @add_to_shop = (1==value.to_i)
  end

  # return image cover url
  def cover_image_url(style=:small)
    image = images.first
    if image
      image.attachment.url(style)
    else
      return false
    end
  end

  def to_liquid(options={})
    ProductDrop.new self, options
  end

  def to_fb_attachment
    attachment = {:caption=>"{*actor*} posted from weeshop",
                  :description=>"#{description}",
                  :name=>name,
                  :href=>"http://robdoan.homedns.org:3000/products/#{id}"}
    medias = []
    for image in images do
      medias << {:type=>'image',
        :src=>"http://robdoan.homedns.org:3000#{image.attachment.url(:mini)}",
        :href=>"http://robdoan.homedns.org:3000#{image.attachment.url(:product)}" }
    end
    if !medias.blank?
      attachment = attachment.merge(:media=>medias)
    end
    attachment
  end


  protected
  # Set shop depent on user
  def shop_user_syn
    if @add_to_shop
      self.shop = self.user.shop
    end
  end
  def add_images
    img_ids = (@image_ids||'').split(',')
    images = Image.with_ids(img_ids)
    transaction do
      for image in images do
        image.update_attribute(:viewable, self)
      end
    end
  end

  def published_to_facebook
    img_ids = (@image_ids||'').split(',')
    user.publish_product(self,img_ids)
  end
end
