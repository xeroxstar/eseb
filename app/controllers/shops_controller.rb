class ShopsController < ApplicationController
  before_filter :login_required, :except=>[:show]
  before_filter :require_shopowner, :except=>[:show]
  def new
    @shop = Shop.new
  end

  def show
    @shop = Shop.find_by_shortname(params[:id])
    unless @shop
      flash[:warning] = 'Shop can not found'
      redirect_to home_url
    end
  end

  def create
    @shop = current_shopowner.build_shop(params[:shop])
    if @shop.save
      flash[:notice] = 'success'
      redirect_to(my_shop_path)
    else
      render :action=>'new'
    end
  end

  def myshop
    @shop = current_shopowner.shop
    unless @shop
      redirect_to :action=>:new
    end
  end

end