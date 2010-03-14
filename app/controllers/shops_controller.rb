class ShopsController < ApplicationController
  before_filter :login_required, :except=>[:show,:index]
  before_filter :full_personal_info_required, :except=>[:show,:index]

  def index
    @shops = Shop.paginate :per_page=>10, :page=>params[:page]
  end

  def new
    if current_user.shop
      redirect_to '/myshop'
    else
      @shop = Shop.new
    end
  end

  def show
    @shop = Shop.find_by_shortname(params[:id])
    unless @shop
      flash[:warning] = 'Shop can not found'
      redirect_to home_url
    end
  end

  def edit
    @shop = current_user.shop
  end

  def update
    @shop = current_user.shop
    if @shop.update_attributes(params[:shop])
      redirect_to my_shop_path
    else
      render :edit
    end
  end

  def create
    @shop= current_user.create_shop(params[:shop])
    if @shop.errors.empty?
      redirect_to(my_shop_path)
    else
      render :action=>'new'
    end
  end

  def myshop
    if current_user.is_a?(ShopOwner)
      @shop = current_user.shop
    else
      redirect_to :action=>:new
    end
  end

  def deactive
    @shop = current_user.shop
    if @shop.deactivate
      redirect_to my_account_url
    end
  end

  def reactive
    @shop = current_user.shop
    @shop.activate
    redirect_to my_shop_path
  end

end