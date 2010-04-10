class ShopDrop < BaseDrop
  liquid_attributes << :name << :shortname
  def initialize(source,options={})
    super source
    @options = options
  end

  def products
    @products || liquify(*@source.products)
  end

  def shop_categories
    @shop_categories || liquify(*@source.shop_categories)
  end
end
