class ShopAdmin::MyShopController < ShopAdmin::ApplicationController
  skip_before_filter :owner_of_shop, :only=>[:new,:create]
  def new
    if current_user.shop
      redirect_to '/myshop'
    else
      @shop = Shop.new
    end
  end
  def index
  end
  def create
    @shop= current_user.create_shop(params[:shop])
    if @shop.errors.empty?
      redirect_to :action=>:address
    else
      render :action=>'new'
    end
  end

  def address
    @address = @shop.addresses.new
  end

  def add_address
    @address = @shop.addresses.new(params[:address])
    if @address.save!
      @shop.do_activate
      redirect_to my_shop_path
    else
      render :address
    end
  end

  def edit
  end

  def update
    if @shop.update_attributes(params[:shop])
      redirect_to my_shop_path
    else
      render :edit
    end
  end

  def deactive
    if @shop.deactivate
      redirect_to my_account_url
    end
  end

  def reactive
    @shop.activate
    redirect_to my_shop_path
  end

end
