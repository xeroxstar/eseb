# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProductDrop < BaseDrop
  liquid_attributes << :name
  def initialize(source,options={})
    super source
    @options  = options
  end

  [:mini, :small, :product, :large ].each do |style|
    define_method("#{style}_cover_image_url") { @source.send(:cover_image_url,style) }
  end

  def images
    @images || liquify(*@source.images)
  end
end
