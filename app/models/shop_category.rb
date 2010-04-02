class ShopCategory < ActiveRecord::Base
  strip_attributes!

  belongs_to :shop
  belongs_to :subcategory , :class_name=>'Category'

  validates_presence_of :name,:subcategory_id
end
