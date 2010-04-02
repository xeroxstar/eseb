# Product
# Represent entity for sale
# A store will have one or many product, and each product belogns to a store
# Product should belongs to a subcateogry , and may be belongs to shop categories
# Shop category must be depend on subcategory

class Product < ActiveRecord::Base
  strip_attributes!
  after_save :add_images
  # Asscociations
  belongs_to :subcategory, :foreign_key => 'category_id', :class_name=>'Category'
  belongs_to :shop_category
  belongs_to :shop
  has_many :images, :as=>:viewable,:dependent => :destroy
  attr_writer :image_ids

  #named scope
  named_scope :in_shop_category , lambda{ |shop_category_id|
    {:conditions=> {:shop_category_id=>shop_category_id}}
  }
  # return ids of product images
  def image_ids
    images.map(&:id).join(',')
  end

  # return image cover url
  def cover_image_url
    image = images.first
    if image
      image.attachment.url(:small)
    else
      '/images/missing.png'
    end
  end

  protected
  def add_images
    img_ids = @image_ids.split(',')
    images = Image.with_ids(img_ids)
    transaction do
      for image in images do
        image.update_attribute(:viewable, self)
      end
    end
  end
end
