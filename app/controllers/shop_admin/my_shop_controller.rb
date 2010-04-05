class ShopAdmin::MyShopController < ShopAdmin::ApplicationController
  skip_before_filter :owner_of_shop, :only=>[:new,:create]
#  layout false , :only=>[:address, :edit_address]

  def show; end
  def new
    if current_user.shop
      redirect_to '/myshop'
    else
      @shop = Shop.new
    end
  end

  def create
    @shop= current_user.create_shop(params[:shop])
    if @shop.errors.empty?
      redirect_to :action=>:address
    else
      render :action=>'new'
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

  # Get address form to create address
  def address
    @address = @shop.addresses.new
    render :layout=>false
  end

  # Add address to shop
  def add_address
    @address = @shop.addresses.new(params[:address])
    if @address.save!
      @shop.do_activate
      redirect_to my_shop_path
    else
      render :address
    end
  end

  def edit_address
    @address = @shop.addresses.find(params[:id])
    render :layout=>false
  end

  def update_address
    @address = @shop.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      redirect_to my_shop_path
    end
  end

  # remove address
  def remove_address
    @address = @shop.addresses.find(params[:id])
    @address.destroy
    redirect_to my_shop_path
  end

  # deactive shop
  def deactive
    if @shop.deactivate
      redirect_to my_account_url
    end
  end

  # Reactivate shop
  def reactive
    @shop.activate
    redirect_to my_shop_path
  end

end
