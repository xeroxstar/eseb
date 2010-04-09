# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProductDrop < BaseDrop
  liquid_attributes << :name
  def initialize(source,options={})
    super source
    @options  = options
  end
  def product_cover_image_url
    @source.cover_image_url(:product)
  end
end
