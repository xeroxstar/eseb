# To change this template, choose Tools | Templates
# and open the template in the editor.

class ShopDrop < BaseDrop
  def initialize(source,options={})
    super source
  end

  def products
    @products ||= liquify(*@source.products)
  end
end
