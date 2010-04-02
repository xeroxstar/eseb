class ShopsController < ApplicationController
  def index
    @shops = Shop.actived.paginate :per_page=>10, :page=>params[:page]
  end

  def show
    @shop = Shop.actived.find_by_shortname(params[:id])
    @products = @shop.products
    if params[:shop_category_id]
      @products = @products.in_shop_category(params[:shop_category_id])
    end
    unless @shop
      flash[:warning] = 'Shop can not found'
      redirect_to home_url
    end
  end

end