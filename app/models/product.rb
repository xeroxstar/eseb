# Product
# Represent entity for sale
# A store will have one or many product, and each product belogns to a store
# Product should belongs to a subcateogry , and may be belongs to shop categories
# Shop category must be depend on subcategory

class Product < ActiveRecord::Base
  strip_attributes!
  belongs_to :subcategory, :foreign_key => 'category_id', :class_name=>'Category'
  belongs_to :shop_category
  belongs_to :shop
end
