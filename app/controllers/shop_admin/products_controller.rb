class ShopAdmin::ProductsController < ShopAdmin::ApplicationController
  before_filter :login_required, :owner_of_shop
  def new
    @product = @shop.products.new
  end

  def edit
    @product = @shop.products.find(params[:id])
  end

  def create
    @product = @shop.products.new(params[:product])
    if @product.save
      redirect_to '/myshop'
    else
      render :new
    end
  end

  def update
    @product = @shop.products.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to '/myshop'
    else
      render :new
    end
  end

  def destroy
    @product = @shop.products.find(params[:id])
    @product.destroy
    redirect_to '/myshop'
  end

end
