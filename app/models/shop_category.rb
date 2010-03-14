class ShopCategory < ActiveRecord::Base
  belongs_to :shop
  belongs_to :subcategory , :class_name=>'Category'

  validates_presence_of :name
end
