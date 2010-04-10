class ShopCategoryDrop < BaseDrop
  liquid_attributes << :name
  def initialize(source,options={})
    super source
    @options  = options
  end
#  def name
#    @source.name
#  end
end
